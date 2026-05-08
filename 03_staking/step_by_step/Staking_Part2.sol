// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Staking_Part2 is Ownable {

    using SafeERC20 for IERC20;

    uint256 private constant PRECISION = 1e18; // 10^18, 소수점 계산을 위한 상수
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardsToken;

    uint256 public duration;
    uint256 public rewardEndAt;
    uint256 public unallocatedRewards;
    uint256 public rewardRate;
    uint256 public totalStaked;
    uint256 private rewardLastUpdateTime;
    uint256 private rewardPerTokenAccumulated;
    mapping(address => uint256) private rewardSnapshot;
    mapping(address => uint256) public rewards;
    mapping(address => uint256) public balanceOf;

    event RewardAdded(uint256 amount, uint256 duration);

    error InvalidStakingToken();
    error InvalidRewardToken();
    error InvalidDuration();
    error InvalidRewardRate();
    error RewardDurationNotFinished();

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

        // 토큰 1개당 누적 보상(전체 구간)
        rewardPerTokenAccumulated = _rewardPerToken();
        rewardLastUpdateTime = _currentRewardTime();

        if (_account != address(0)) {
            // 저장된 확정 보상
            rewards[_account] = earned(_account);
            rewardSnapshot[_account] = rewardPerTokenAccumulated;
        }
        _;
    }

    constructor(address _stakingToken, address _rewardToken) Ownable(msg.sender) {
        if (_stakingToken == address(0)) revert InvalidStakingToken();
        if (_rewardToken == address(0)) revert InvalidRewardToken();

        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardToken);
    }


    function _rewardPerToken() private view returns(uint256) {

        // 토큰 1개당 보상(이번 구간) =  (초당 보상량 x 경과시간) / 총 스테이킹량
        // 토큰 1개당 누적 보상(전체 구간) = 이전 누적 보상 + ((초당 보상량 x 경과시간) / 총 스테이킹량)
        // 토큰 1개당 누적 보상(전체 구간) = 이전 누적 보상 +  토큰 1개당 보상(이번 구간)
        if(totalStaked == 0) return rewardPerTokenAccumulated;
        return rewardPerTokenAccumulated + (rewardRate * (_currentRewardTime() - rewardLastUpdateTime) * PRECISION / totalStaked); 
    }

    function _currentRewardTime() internal view returns (uint256) {
        // 보상기간이면 현재 시간, 보상기간이 끝났으면 보상기간 종료 시각 반환
        // 즉 min(block.timestamp, rewardEndAt)
        return rewardEndAt <= block.timestamp ? rewardEndAt : block.timestamp;
    } 

    function earned(address _account) public view returns (uint256) {
        // 유저 보상 = 저장된 확정 보상(현재까지 쌓인 보상) + (스테이킹된 토큰 * ( 토큰 1개당 누적 보상(전체구간) - 스냅샷(유저진입전 토큰 1개당 누적 보상))
        return rewards[_account] + ( balanceOf[_account] *  (_rewardPerToken() - rewardSnapshot[_account]) / PRECISION);
    }

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

}