// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*

    변수 (Variable)
    - 데이터를 저장하기 위해 사용하는 공간이다. 
    - 변수는 동일한 타입 (자료형) 내에서 값 변경이 가능하다.
    - 변수는 크게 3가지로 상태 변수, 지역 변수, 전역 변수로 구분된다.
     
    상태 변수 (State Variables)
    - 컨트랙트 내부, 함수 밖에 선언되는 변수이다. 
    - storage에 영구적으로 저장된다.
     - 컨트랙트 내 모든 함수에서 접근이 가능하다. 
    지역 변수 (Local Variables)
    - 함수 내부에서 선언되는 변수이다.
    - memory에 저장되며, 함수가 종료되면 사라진다.  
    전역 변수 (Global Variables)
    - 솔리디티에서 제공하는 특수한 변수이다.
    - 블록, 트랜잭션, 호출자 등의 정보를 조회할 수 있다.  
    
    block
    - block.blockhash(uint blockNumber) returns (bytes32)
      주어진 블록의 해시 (최근 256개 블록까지만 조회 가능)  
    - block.coinbase (address)
      블록을 생성한 validator의 주소  
    - block.prevrandao (uint)
      랜덤 값 (이전 block.difficulty 대체)  
    - block.gaslimit (uint)
      현재 블록의 gas limit 
    - block.number (uint)
      현재 블록 번호  
    - block.timestamp (uint)
      현재 블록 생성 시간 (unix timestamp)  
    msg
    - msg.data (bytes)
      전체 calldata 
    - msg.sender (address)
      현재 호출자 주소  
    - msg.sig (bytes4)
      함수 selector (calldata의 첫 4바이트) 
    - msg.value (uint)
      함께 전송된 wei 값  
    tx    
    - tx.gasprice (uint)
      트랜잭션 gas 가격   
    - tx.origin (address)
      트랜잭션 최초 호출자  
    - gasleft() returns (uint256)
      남은 gas 양
*/



contract Lec08_State_Local_GlobalVariables {

    // 상태 변수
    uint256 public value = 5;

    // 상태 변수, 전역 변수 
    address public owner = msg.sender;

    function add() public view returns(uint256) {
        // 로컬 변수
        uint256 x = 100;
        return x + value;
    }

    /*
    // 로컬 변수 접근이므로 오류발생
    function getX() public view returns(uint256) {
        return x;
    }
    */

    function getOwnerAndTimeStamp() public view returns(address, uint256) {
        return (owner, block.timestamp);
    }

}