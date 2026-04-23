// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Staking is Ownable {
    /*//////////////////////////////////////////////////////////////
                              USINGS
    //////////////////////////////////////////////////////////////*/

    using SafeERC20 for IERC20;

    /*//////////////////////////////////////////////////////////////
                              CONSTANTS
    //////////////////////////////////////////////////////////////*/

    uint256 private constant PRECISION = 1e18; // 10^18, 소수점 계산을 위한 상수
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardsToken;

    /*//////////////////////////////////////////////////////////////
                                STATE
    //////////////////////////////////////////////////////////////*/

    uint256 public duration;
    uint256 public rewardEndAt;
    uint256 public unallocatedRewards;
    uint256 private rewardLastUpdateTime;
    uint256 private rewardRate;
    uint256 private rewardPerTokenAccumulated;
   
    /*//////////////////////////////////////////////////////////////
                             ACCOUNTING
    //////////////////////////////////////////////////////////////*/

    mapping(address => uint256) private rewardSnapshot;
    mapping(address => uint256) public rewards;

    /*//////////////////////////////////////////////////////////////
                               STAKING
    //////////////////////////////////////////////////////////////*/

    uint256 public totalStaked;
    mapping(address => uint256) public balanceOf;

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
    error InsufficientRewardBalance();
    error InsufficientRewardAmount();
    error RewardDurationNotFinished();
    error CannotRecoverStakingToken();
    error CannotRecoverRewardsToken();

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
                               MODIFIERS
    //////////////////////////////////////////////////////////////*/

    // 보상 상태 업데이트
    modifier updateReward(address _account) {
        /*
            updateReward 역할
            1. 스테이킹 참여자 부재시 구간의 미할당 보상 누적
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

        // 스테이킹 토큰 1개당 각 구간별 총 누적 보상 
        rewardPerTokenAccumulated = rewardPerToken();
        rewardLastUpdateTime = _currentRewardTime();

        if (_account != address(0)) {
            // 저장된 확정 보상
            rewards[_account] = earned(_account);
            rewardSnapshot[_account] = rewardPerTokenAccumulated;
        }
        _;
    }
    /*//////////////////////////////////////////////////////////////
                           INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function _currentRewardTime() internal view returns (uint256) {
        // 보상기간이면 현재 시간, 보상기간이 끝났으면 보상기간 종료 시각 반환
        // 즉 min(block.timestamp, rewardEndAt)
        return rewardEndAt <= block.timestamp ? rewardEndAt : block.timestamp;
    }

    /*//////////////////////////////////////////////////////////////
                            VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function rewardPerToken() public view returns (uint256) {
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

    function earned(address _account) public view returns (uint256) {
        // 유저 진입 이후 스테이킹 토큰 1개당 누적된 보상 : (rewardPerToken() - rewardSnapshot[_account])
        // PRECISION 나누는 이유: rewardPerToken()에서 PRECISION 곱했으므로, 원래 값으로 복원하기 위해 나눔
        return (
            balanceOf[_account] *
            (rewardPerToken() - rewardSnapshot[_account]) /
            PRECISION
        ) + rewards[_account];
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

        stakingToken.safeTransferFrom(msg.sender, address(this), _amount);

        balanceOf[msg.sender] += _amount;
        totalStaked += _amount;

        emit Staked(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) public updateReward(msg.sender) {
        if (_amount == 0) revert InvalidAmount();
        if (balanceOf[msg.sender] < _amount) revert InsufficientBalance();

        balanceOf[msg.sender] -= _amount;
        totalStaked -= _amount;

        stakingToken.safeTransfer(msg.sender, _amount);

        emit Withdrawn(msg.sender, _amount);
    }

    function claim() public updateReward(msg.sender) {
        uint256 reward = rewards[msg.sender];
        if (reward == 0) revert InsufficientRewardAmount();

        rewards[msg.sender] = 0;
        rewardsToken.safeTransfer(msg.sender, reward);

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

    // 보상 금액 설정 (보상 기간이 끝나지 않아도 새 보상 금액 설정 가능)
    function setRewardAmount(uint256 _amount)
        external
        onlyOwner
        updateReward(address(0))
    {
        if (duration == 0) revert InvalidDuration();

        // 보상 토큰을 컨트랙트로 전송
        rewardsToken.safeTransferFrom(msg.sender, address(this), _amount);

        // Case1: 최초 시작시 또는 보상 기간이 끝났을 때 보상 추가
        if (block.timestamp >= rewardEndAt) {
            // 초당 보상량 계산
            rewardRate = _amount / duration;
        } 
        // Case2: 보상기간이 끝나지 않았을 때 보상 추가
        else {
            // 남은 보상량과 새로 추가할 보상량을 합산 후 남은 기간으로 나눠 초당 보상량 계산
            uint256 remainingRewards = (rewardEndAt - block.timestamp) * rewardRate;
            rewardRate = (_amount + remainingRewards) / duration;
        }

        if (rewardRate == 0) revert InvalidRewardRate();

        // 보상 기간의 종료 시각 설정
        rewardEndAt = block.timestamp + duration;

        // rewardPerToken 계산 기준이 되는 마지막 업데이트 시각
        // 구간의 시작점
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
        rewardsToken.safeTransfer(msg.sender, amount);

        emit UnallocatedRewardsWithdrawn(amount);
    }

    // 실수로 전송된 ERC20 회수 (스테이킹 토큰과 보상 토큰은 회수 불가)
    function recoverERC20(address _token, uint256 _amount) external onlyOwner {
        if (_token == address(stakingToken)) revert CannotRecoverStakingToken();
        if (_token == address(rewardsToken)) revert CannotRecoverRewardsToken();

        IERC20(_token).safeTransfer(msg.sender, _amount);
    }
}