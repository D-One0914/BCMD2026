// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Staking_Part1 {

    uint256 private constant PRECISION = 1e18; // 10^18, 소수점 계산을 위한 상수

    uint256 public rewardEndAt;
    uint256 public unallocatedRewards;
    uint256 public rewardRate;
    uint256 public totalStaked;
    uint256 private rewardLastUpdateTime;
    uint256 private rewardPerTokenAccumulated;
    mapping(address => uint256) private rewardSnapshot;
    mapping(address => uint256) public rewards;
    mapping(address => uint256) public balanceOf;



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


}