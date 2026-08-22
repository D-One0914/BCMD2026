// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleStaking is Ownable {

    /*//////////////////////////////////////////////////////////////
                              CONSTANTS
    //////////////////////////////////////////////////////////////*/

    uint256 private constant PRECISION = 1e18; // 10^18, 소수점 계산을 위한 상수
    IERC20 public immutable stakingToken; // 스테이킹할 토큰 
    IERC20 public immutable rewardsToken; // 보상 받을 토큰 (스테이킹으로 인한)

    /*//////////////////////////////////////////////////////////////
                                STATE
    //////////////////////////////////////////////////////////////*/

    uint256 public duration; // 스테이킹 보상 기간
    uint256 public rewardEndAt; // 보상이 끝나는 시점
    uint256 public unallocatedRewards; // 미할당 보상 (스테이킹 참여자 부재시)
    uint256 public rewardRate; // 초당 보상량 (총 보상량 / 보상 기간(=duration))
    uint256 public totalStaked; // 현재 스테이킹된 량

    /*
    rewardLastUpdateTime
    - 현재 보상 계산 구간의 끝이자 다음 보상 계산 구간의 시작 시각
    - 각 구간은 전체 스테이킹 수량에 따라 토큰 1개당 보상 계산값이 달라질 수 있음
    - stake와 withdraw는 스테이킹 수량 변경 시, claim은 누적 보상 정산 시 최신화됨
    */
    uint256 private rewardLastUpdateTime;

   
    /*
    rewardPerTokenAccumulated
    - 각 보상 계산 구간에서 발생한 스테이킹 토큰 1개당 보상량의 누적 합계
    - stake, withdraw, claim 시 현재 구간까지의 보상을 계산하여 최신화함
    - 모든 유저의 보상을 계산할 때 사용하는 공통 누적 기준값

    ex)
        - rewardRate(초당 보상량) = 1 

        - 0초 ~ 100초  (100초 경과)
        - 100초        : Alice가 1개 스테이킹 
                        스테이킹 전 totalStaked (0 ~ 100초 구간) : 0 
                        rewardPerTokenAccumulated = 0
                        unallocatedRewards = 100 

                        스테이킹 후 totalStaked (100초 ~ 이후 구간) : 1

        - 100초 ~ 300초 (200초 경과)
        - 300초        :  Bob 3개 스테이킹 
                         스테이킹 전 totalStaked (100초 ~ 300초 구간) : 1 
                         100초 ~ 300초 구간의 토큰 1개당 보상량 
                            = (구간 소요 시간(초) / 총 스테이킹 량) * 초당 보상량 
                            = (200 / 1) * 1 = 200
                        
                        rewardPerTokenAccumulated = 200
                        스테이킹 후 totalStaked (100초 ~ 이후 구간) = 1 + 3 = 4
                        

        - 300초 ~ 1000초  (700초 경과)
        - 1000초       :  Alice가 1개 모두 출금
                        출금 전 totalStaked : 4

                        300초 ~ 1000초 구간의 토큰 1개당 보상량 
                            = (구간 소요 시간(초) / 총 스테이킹 량) * 초당 보상량 
                            = (700 / 4) * 1 = 175

                        rewardPerTokenAccumulated = 200(100초 ~ 300초 구간) + 175(300초 ~ 1000초 구간) = 375
                        출금 후 totalStaked : 3
    */
    uint256 private rewardPerTokenAccumulated;

    /*
    rewardSnapshot 
    - 이전 구간의 스테이킹 토큰 1개당 보상량의 누적 합계 rewardPerTokenAccumulated를 저장  
    - stake, withdraw, claim 시 해당 유저의 rewardSnapshot 갱신됨
    - 유저가 보상을 받을 수 있는 구간의 시작 기준점
    - 총 토큰 1개당 보상 - rewardSnapshot (유저가 스테이킹 하기전 스테이킹 토큰 1개당 보상량의 누적 합계)

    ex) 
        - rewardRate(초당 보상량) = 1 

        - 0초 ~ 100초  (100초 경과)
        - 100초        : Alice가 1개 스테이킹 
                        스테이킹 전 totalStaked (0 ~ 100초 구간) : 0  
                        스테이킹 전 balanceOf[Alice] = 0
                        rewardPerTokenAccumulated = 0
                        rewardSnapshot[Alice] = rewardPerTokenAccumulated = 0
                        unallocatedRewards = 10
                        스테이킹 후 totalStaked (100초 ~ 이후 구간) : 1
                        스테이킹 후 balanceOf[Alice] = 1

        - 100초 ~ 300초 (200초 경과)
        - 300초        : Bob 3개 스테이킹  
                        스테이킹 전 totalStaked (100초 ~ 300초 구간) = 1 
                        스테이킹 전 balanceOf[Bob] = 0
                        100초 ~ 300초 구간의 토큰 1개당 보상량 
                            = (구간 소요 시간(초) / 총 스테이킹 량) * 초당 보상량 
                            = (200 / 1) * 1 = 200
                        
                        rewardPerTokenAccumulated = 200
                        rewardSnapshot[Bob] = rewardPerTokenAccumulated = 200

                        스테이킹 후 totalStaked (100초 ~ 이후 구간) = 1 + 3 = 4
                        스테이킹 후 balanceOf[Bob] = 3 
        
        - 300초 ~ 1000초  (700초 경과)
        - 1000초       :  Alice가 1개 모두 출금
                        출금 전 totalStaked : 4

                        300초 ~ 1000초 구간의 토큰 1개당 보상량 
                            = (구간 소요 시간(초) / 총 스테이킹 량) * 초당 보상량 
                            = (700 / 4) * 1 = 175

                        rewardPerTokenAccumulated = 200(100초 ~ 300초 구간) + 175(300초 ~ 1000초 구간) = 375
                        rewardSnapshot[Alice] = rewardPerTokenAccumulated = 375

                        출금 후 totalStaked = 4 - 1 = 3
                        출금 후 balanceOf[Alice] = 3
    */

    mapping(address => uint256) private rewardSnapshot;

    /*
    rewards
    - 확정된 보상을 나타냄
    - 보상은 예상 보상과 확정 보상이 있으며, 예상 보상은 계산상 보상의 량을 나타내며, 확정 보상은 계산상 보상의 량을 저장한 값
    - 이처럼 두개의 보상이 존재하는 이유는, 블록체인 특성상 값을 저장하기 위해서는 가스 비용이 들기에 유저가 트랜잭션을 날리기전까지는 보상의 값을 저장하지 않고 계산을 함
    - 유저가 stake, withdraw, claim 시, 그동안의 보상량을 계산 한 후 rewards에 저장. 

    ex) 
        
        - rewardRate(초당 보상량) = 1 

        - 0초 ~ 100초  (100초 경과)
        - 100초        : Alice가 1개 스테이킹
                        스테이킹 전 totalStaked (0 ~ 100초 구간) : 0 
                        스테이킹 전 balanceOf[Alice] = 0
                        rewardPerTokenAccumulated = 0
                        rewardSnapshot[Alice] = rewardPerTokenAccumulated = 0
                        rewards[Alice] = 0
                        unallocatedRewards = 10
                        스테이킹 후 totalStaked = 2
                        스테이킹 후 balanceOf[Alice] = 2

        - 100초 ~ 300초 (200초 경과)
        - 300초        :  Bob 3개 스테이킹 
                        스테이킹 전 totalStaked (100초 ~ 300초 구간) : 1
                        스테이킹 전 balanceOf[Bob] = 0
                        스테이킹 전 rewards[Bob] = 0
                        스테이킹 전 rewardSnapshot[Bob] = 0 

                        100초 ~ 300초 구간의 토큰 1개당 보상량 
                            = (구간 소요 시간(초) / 총 스테이킹 량) * 초당 보상량 
                            = (200 / 1) * 1 = 200
                        
                        rewardPerTokenAccumulated = 200

                        스테이킹 후 rewardSnapshot[Bob] (300초 ~ 이후 구간) = rewardPerTokenAccumulated = 200
                        스테이킹 후 totalStaked = 1 + 3 = 4
                        스테이킹 후 balanceOf[Bob] = 3 
                        스테이킹 후 rewards[Bob] = 0
        
        - 300초 ~ 1000초  (700초 경과)
        - 1000초       :  Alice가 1개 모두 출금
                        출금 전 totalStaked : 4
                        출금 전 balanceOf[Alice] = 1
                        출금 전 rewards[Alice] = 0
                        출금 전 rewardSnapshot[Alice] = 0 

                        300초 ~ 1000초 구간의 토큰 1개당 보상량 
                            = (구간 소요 시간(초) / 총 스테이킹 량) * 초당 보상량 
                            = (700 / 4) * 1 = 175

                        rewardPerTokenAccumulated = 200(100초 ~ 300초 구간) + 175(300초 ~ 1000초 구간) = 375
                        rewardSnapshot[Alice] = rewardPerTokenAccumulated = 375

                        출금 후 rewardSnapshot[Alice] (1000초 ~ 이후 구간) = rewardPerTokenAccumulated = 200
                        출금 후 totalStaked = 4 - 1 = 3
                        출금 후 balanceOf[Alice] = 0 
                        출금 후 reward[Alice] = 200 (100초 ~ 200초 구간) + 175 (300초 ~ 1000초 구간) = 375

        1000초 당시 Alice의 총 예상 보상량 - 출금 했으므로 연산 후 저장 O, rewardSnapshot[Alice] 업데이트
        rewards[Alice] = 이전 확정 보상 + ((총 구간 토큰 1개당 누적 보상 - 유저의 마지막 보상 기준값) * 유저 스테이킹 수량)
        rewards[Alice] =  0 + (375 - 0) * 1 = 375                

        1000초 당시 Bob의 총 예상 보상량 - 스테이킹, 출금, 클레임 하지 않았으므로 저장 X, 오직 연산
        rewards[Bob] = 이전 확정 보상 + ((총 구간 토큰 1개당 누적 보상 - 유저의 마지막 보상 기준값) * 유저 스테이킹 수량)
        rewards[Bob] =  0 + (375 - 200) * 3 = 175 * 3 = 525       

        - 1000초 ~ 1300초  (300초 경과)
        - 1300초    : Alice 7개 스테이킹
                    스테이킹 전 totalStaked (100초 ~ 300초 구간) : 3
                    스테이킹 전 balanceOf[Alice] = 0
                    스테이킹 전 rewards[Alice] = 375
                    스테이킹 전 rewardSnapshot[Alice] = 200 

                    1000초 ~ 1300초 구간의 토큰 1개당 보상량 
                        = (구간 소요 시간(초) / 총 스테이킹 량) * 초당 보상량 
                        = (300 / 3) * 1 = 100 

                    rewardPerTokenAccumulated = 200(100초 ~ 300초 구간) + 175(300초 ~ 1000초 구간) + 100(1000초 ~ 1300초 구간) = 475
                    rewardSnapshot[Alice] = rewardPerTokenAccumulated = 475
                    
                    스테이킹 후 rewardSnapshot[Alice] (1300초 ~ 이후 구간) = rewardPerTokenAccumulated = 475
                    스테이킹 후 totalStaked = 3 + 7 = 10
                    스테이킹 후 balanceOf[Alice] = 7 
                    스테이킹 후 rewards[Alice] = 375

        - 200초 후 1400초 당시 Alice, bob 총 예상 보상량 - 스테이킹, 출금, 클레임 하지 않았으므로 저장 X, 오직 연산
        - totalStaked = 10
        - 1000초 ~ 1300초 구간의 토큰 1개당 보상량 
            = (구간 소요 시간(초) / 총 스테이킹 량) * 초당 보상량 
            = (200 / 10) * 1 = 20 
        - 예상 rewardPerTokenAccumulated =  475 + 20(1000초 ~ 1300초 구간) = 495    
        
        - Alice
        rewards[Alice] = 이전 확정 보상 + ((총 구간 토큰 1개당 누적 보상 - 유저의 마지막 보상 기준값) * 유저 스테이킹 수량)             
        rewards[Alice] = 375 + ((495 - 475) * 7) =  375 + (20 * 7) = 375 + 140 = 515   

        - Bob
        rewards[Bob] = 이전 확정 보상 + ((총 구간 토큰 1개당 누적 보상 - 유저의 마지막 보상 기준값) * 유저 스테이킹 수량)             
        rewards[Bob] = 0 + ((495 - 200) * 3) =  0 + (295 * 3) = 885   
       
    */

    mapping(address => uint256) public rewards; // 확정 보상
    mapping(address => uint256) public balanceOf; // 각 유저가 현재 스테이킹하고 있는 토큰 수량

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
    event RewardAdded(uint256 amount, uint256 duration);
    event UnallocatedRewardsWithdrawn(uint256 amount); 

    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/

    error InvalidStakingToken();
    error InvalidRewardToken();
    error InvalidAmount();
    error InvalidDuration();
    error InvalidRewardRate();
    error InsufficientBalance();
    error InsufficientRewardAmount();
    error RewardDurationNotFinished();

    /*//////////////////////////////////////////////////////////////
                               MODIFIERS
    //////////////////////////////////////////////////////////////*/

    // 보상 상태 업데이트
    modifier updateReward(address _account) {
        /*
            updateReward 역할
            1. 미할당 보상 누적 (스테이킹 참여자 부재 구간)
            2. accRewardPerToken 최신화
            3. rewardLastUpdateTime 최신화
            4. _account의 예상 보상을 확정 보상으로 저장 (rewards[_account])
            5. _account의 스냅샷 최신화 (rewardSnapshot[_account])
        */

        // 미할당 보상 : 스테이킹 참여자가 없고, 보상 기간이 진행중일때
        if (totalStaked == 0 && block.timestamp <= rewardEndAt) {
            // unallocatedRewards = unallocatedRewards + rewardRate * (_currentRewardTime() - rewardLastUpdateTime);
            unallocatedRewards += rewardRate * (_currentRewardTime() - rewardLastUpdateTime);
        }

        // 토큰 1개당 누적 보상(전체 구간)
        rewardPerTokenAccumulated = _rewardPerToken();
        rewardLastUpdateTime = _currentRewardTime();

        if (_account != address(0)) {
            // 저장된 확정 보상(현재까지 쌓인 보상)
            rewards[_account] = earned(_account);
            rewardSnapshot[_account] = rewardPerTokenAccumulated;
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address _stakingToken, address _rewardToken) Ownable(msg.sender) {
        if (_stakingToken == address(0)) revert InvalidStakingToken();
        if (_rewardToken == address(0)) revert InvalidRewardToken();

        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardToken);
    }

    /*//////////////////////////////////////////////////////////////
                           Private FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function _rewardPerToken() private view returns (uint256) {
        if (totalStaked == 0) {
            return rewardPerTokenAccumulated;
        }
        
        // 스테이킹 토큰 1개당 누적 보상 + 스테이킹 토큰 1개당 새로 쌓인 보상
        // PRECISION 곱하는 이유: 분자의 값보다 큰 수인 totalStaked가 나누어 질수 있으므로, 소수점 계산을 방지하기 위해 PRECISION(10^18) 곱함
        // 예: 10 / 1000 = 0   
        return rewardPerTokenAccumulated
            + (rewardRate * (_currentRewardTime() - rewardLastUpdateTime) * PRECISION)
            / totalStaked;
    }

    function _currentRewardTime() private view returns (uint256) {
        // 보상기간이면 현재 시간, 보상기간이 끝났으면 보상기간 종료 시각 반환
        // 즉 min(block.timestamp, rewardEndAt)
        return rewardEndAt <= block.timestamp ? rewardEndAt : block.timestamp;
    }

    /*//////////////////////////////////////////////////////////////
                            VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function rewardPerToken() public view returns (uint256) {
        // 외부 조회용이므로, 계산 정밀도를 위해 곱해졌던 PRECISION(10^18)을 다시 나누어 본래의 단위로 복원
        return _rewardPerToken() / PRECISION;
    }

    function earned(address _account) public view returns (uint256) {
        // 유저 보상 = 저장된 확정 보상(현재까지 쌓인 보상) + (스테이킹된 토큰 * ( 토큰 1개당 누적 보상(전체구간) - 스냅샷(유저진입전 토큰 1개당 누적 보상))
        // PRECISION 나누는 이유: _rewardPerToken()에서 PRECISION 곱했으므로, 원래 값으로 복원하기 위해 나눔
        return rewards[_account] + ( balanceOf[_account] *  (_rewardPerToken() - rewardSnapshot[_account]) / PRECISION);
    }

    function totalUnallocatedRewards() public view returns (uint256) {
        
        uint256 pendingEmission = rewardRate * ( _currentRewardTime() - rewardLastUpdateTime);
    
        // 이 구간에 스테이킹 참여자가 없으면 전부 미할당
        uint256 pendingUnallocatedRewards = (totalStaked == 0) ? pendingEmission : 0;
    
        return unallocatedRewards + pendingUnallocatedRewards;
    }

    /*//////////////////////////////////////////////////////////////
                            CORE FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function stake(uint256 _amount) external updateReward(msg.sender) {
        if (_amount == 0) revert InvalidAmount();

        stakingToken.transferFrom(msg.sender, address(this), _amount);

        balanceOf[msg.sender] += _amount;
        totalStaked += _amount;

        emit Staked(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) public updateReward(msg.sender) {
        if (_amount == 0) revert InvalidAmount();
        if (balanceOf[msg.sender] < _amount) revert InsufficientBalance();

        balanceOf[msg.sender] -= _amount;
        totalStaked -= _amount;

        stakingToken.transfer(msg.sender, _amount);

        emit Withdrawn(msg.sender, _amount);
    }

    function claim() public updateReward(msg.sender) {
        uint256 reward = rewards[msg.sender];
        if (reward == 0) revert InsufficientRewardAmount();

        rewards[msg.sender] = 0;
        rewardsToken.transfer(msg.sender, reward);

        emit RewardPaid(msg.sender, reward);
    }

    function exit() external {
        uint256 staked = balanceOf[msg.sender];

        if (staked > 0) {
            withdraw(staked);
        }

        if (rewards[msg.sender] > 0) {
            claim();
        }
    }


    /*//////////////////////////////////////////////////////////////
                           ADMIN FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    // 보상 기간 설정 (보상 기간이 끝나야 새 보상 기간 설정 가능)
    function setRewardsDuration(uint256 _duration) external onlyOwner {
        if (_duration == 0) revert InvalidDuration();
        if (rewardEndAt >= block.timestamp) revert RewardDurationNotFinished();

        duration = _duration;
    }

    // 보상 금액 설정 (기존 보상 기간이 끝난 후에만 새 보상 설정 가능)
    function setRewardAmount(uint256 _amount)
        external
        onlyOwner
        updateReward(address(0))
    {
        if (duration == 0) revert InvalidDuration();
        if (block.timestamp < rewardEndAt) revert RewardDurationNotFinished();

        // 초당 보상량 계산
        uint256 newRewardRate = _amount / duration;

        if (newRewardRate == 0) revert InvalidRewardRate();

        // 보상 토큰을 컨트랙트로 전송
        rewardsToken.transferFrom(
            msg.sender,
            address(this),
            _amount
        );

        rewardRate = newRewardRate;

        // 새로운 보상 기간 설정
        rewardEndAt = block.timestamp + duration;

        // 보상 계산 시작 시각
        rewardLastUpdateTime = block.timestamp;

        emit RewardAdded(_amount, duration);
    }

    // 보상 기간 종료 후 미할당된 보상 회수 (보상 기간 동안 스테이킹 참여자 없어 누적된 보상)
    function withdrawUnallocatedRewards() external onlyOwner {
        // 보상 기간 종료 후 호출 가능하도록 제한
        if (block.timestamp < rewardEndAt) revert RewardDurationNotFinished();

        // 미할당된 보상 금액 계산
        uint256 amount = totalUnallocatedRewards(); 
        
        unallocatedRewards = 0;
        rewardLastUpdateTime = rewardEndAt; 
        rewardsToken.transfer(msg.sender, amount);

        emit UnallocatedRewardsWithdrawn(amount);
    }
}