// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    modifier
  
    - 동일한 조건문이 여러 함수에서 반복될 경우, modifier로 정의하여 재사용할 수 있다.
    - 코드 중복을 줄이고 가독성과 유지보수성을 향상시킨다.
    - 함수 실행 전/후에 특정 조건을 강제하는 기능이다.
    - 주로 접근 제어, 입력값 검증, 상태 체크 등에 사용된다.
    - 함수처럼 파라미터(입력값)를 받을 수 있다
    - "_" 위치에 원래 함수 로직이 삽입되며, modifier의 실행 순서를 결정한다.
     
 */

contract Lec17_Modifier {
    event ModifierExecutedBefore(uint256 input);
    event ModifierExecutedAfter(uint256 input);
    event ActionExecuted(address indexed caller);

    error NotOwner();
    error NotGT10();

   
    uint256 public multipler;
    address public owner;

    // Owner만 실행 가능한 모디파이어
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    // 함수 로직 실행 전
    modifier beforeExecution(uint256 input) {
        emit ModifierExecutedBefore(input);
        _;
    }

    // 함수 로직 실행 후
    modifier afterExecution(uint256 input) {
        _;
        emit ModifierExecutedAfter(input);
    }

    constructor() {
        owner = msg.sender;
    }

    function actionBefore() external beforeExecution(2) {
       emit ActionExecuted(msg.sender);
    }

    function actionAfter() external afterExecution(2) {
        emit ActionExecuted(msg.sender);
    }
}
