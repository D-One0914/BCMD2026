// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    이벤트 (Event)
     - 이벤트는 트랜잭션 로그(log)에 저장되며, 상태 변수처럼 저장(storage)에 기록되지 않는다.
     - 주로 프론트엔드나 서버에 특정 정보를 조회할 때 사용한다. 
     - emit 키워드를 사용하여 이벤트를 발생시킨다.
     - gas 비용이 storage에 저장하는 것보다 저렴하다.
     - 스마트 컨트랙트 내부에서는 직접 접근할 수 없다.

    이벤트 키워드 
    
    emit 
     - 이벤트를 발생시킨다. 

    indexed 
     - 최대 3개의 파라미터에 indexed를 붙일 수 있다.
     - indexed가 붙은 값은 외부에서 검색이 가능하다.


    이벤트 생성법
    event Transfer(address indexed from, address indexed to, uint256 amount);

    emit Transfer(msg.sender, to, amount);
*/

contract Lec18_Event {
    event Executed(address indexed executor, uint256 timestamp);

    function execute() external {
        emit Executed(msg.sender, block.timestamp);
    }

}

