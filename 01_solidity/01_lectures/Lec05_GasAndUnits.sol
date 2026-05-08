// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/*
    가스 (Gas)
    
    - 블록체인에 트랜잭션을 실행할 때는 가스 비용을 지불해야 한다.
    - 상태(storage)가 변경되는 작업일수록 더 많은 가스가 필요하다.
    - 예: ETH 전송, 컨트랙트 배포, 상태 변수 변경 등
    - 하나의 블록에는 목표(target)와 최대(max) 가스가 존재한다.
    - 현재 기준으로 target은 약 30M gas, 최대는 약 60M gas이다.
    - 현재 기준 트랜잭션 최대 가스 한도는 약 16.7M (2^24)

    Gas 단위
    - gas 비용은 보통 Gwei 단위로 표현된다.
    - 1 Gwei = 10^9 wei
    
    
    EIP-1559 (가스 비용 구조 변경)
    
    - 이전: 사용자가 gas price를 직접 지정
    - 현재: gasUsed × (base fee + priority fee) 구조 사용
    
    1. Base Fee
    - 네트워크 혼잡도에 따라 자동으로 결정되는 기본 수수료이다.
    - 이전 블록의 가스 사용량이 목표(target)보다 많으면 base fee가 증가하고, 적으면 base fee가 감소하며, 단 같으면 base fee는 변하지 않는다.
    - 한 블록당 최대 약 12.5%까지만 변동되며, 이는 급격한 폭등/폭락을 막기 위한 제한이다.
    - 이 비용은 소각(burn)된다.
    
    2. Priority Fee (Tip)
    - 블록 생성자(validator)에게 주는 추가 보상
    - 트랜잭션을 더 빠르게 처리하기 위해 사용
    
    3. Max Fee Per Gas
    - 사용자가 지불할 최대 gas 가격
    - 실제로는 base fee + priority fee 만큼만 사용됨
    - 남는 금액은 환불된다.
    
    EIP-4844 (Blob Gas 도입)

    - 기존: L2 데이터가 calldata로 저장되어 높은 가스 비용 발생
    - 현재: Blob이라는 별도의 데이터 공간을 사용해 비용 절감

    - Blob은 블록에 포함되지만 상태(state)에 저장되지 않는 데이터다
    - 일정 기간 후 삭제되는 임시 데이터다

    - Solidity 저장 영역이 아닌, 블록에 포함된 별도의 데이터 공간이다

    - 일반 가스(Execution Gas)와 별도로 Blob Gas라는 새로운 가스 시장이 존재한다
    - 기존 calldata보다 저렴한 비용이다

    - L2(롤업)에서 사용되며 네트워크 혼잡 감소 효과가 있다
    - 전체 가스 비용 감소에 기여한다


    단위
    Solidity에서 제공하는 Ether 단위와 시간 단위를 제공한다. 
    
    Ether 단위
    - wei: 10^0 wei = 1 wei
    - gwei: 10^9 wei  = 1,000,000,000 wei 
    - ether: 10^18 wei = 1,000,000,000,000,000,000 wei
    - 예시: 1 gwei = 1,000,000,000 wei = 0.000000001 ether
    
    시간 단위
    - seconds: 1초
    - minutes: 60초
    - hours: 3600초
    - days: 86400초
    - weeks: 604800초
 */

 contract Lec05_GasAndUnits {
    
    uint256 public oneWei = 1 wei;
    uint256 public oneGwei = 1 gwei;
    uint256 public oneEther = 1 ether;

    uint256 public oneSecond = 1 seconds;
    uint256 public oneMinute = 1 minutes;
    uint256 public oneHour = 1 hours;
    uint256 public oneDay = 1 days;
    uint256 public oneWeek = 1 weeks;

    
 }