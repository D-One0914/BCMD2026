// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    receive / fallback

    1. receive()
    - 해당 함수를 통해 스마트 컨트랙트의 주소로 ETH를 받을 수 있으며, ETH 수신시  receive 함수가 실행된다. 
    - 반드시 external payable 형태로 선언해야 한다.
    - 솔리디티 0.6부터 도입됐다.


    receive() external payable {

    }

    2. fallback()
    - 스마트 컨트랙트에 존재하지 않는 호출될때 실행되는 함수이다. 
    - 또한 receive 함수가 없고 ETH가 전송될 경우에도 실행된다 단, payable 키워드가 있어야 ETH를 받을 수 있다.


    fallback() external payable {

    }

    receive vs fallback 차이

    - receive
      : 순수 ETH 전송

    - fallback
      : 잘못된 함수 호출 
      : receive가 없을 경우 ETH 수신도 fallback이 처리

 */


// 송신 컨트랙트
contract Lec24_Sender {

    // send/transfer로 ETH 전송시, 수신 컨트랙트는 최대 2300 gas만 전달받음
    function sendWithSend(address _to) external payable returns (bool) {
        return payable(_to).send(msg.value);
    }

    // send/transfer로 ETH 전송시, 수신 컨트랙트는 최대 2300 gas만 전달받음
    function sendWithTransfer(address _to) external payable {
        payable(_to).transfer(msg.value);
    }

    // call로 ETH 전송시, 수신 컨트랙트는 대부분의 남은 gas를 전달받음
    function sendWithCall(address _to) external payable {
        (bool success, ) = _to.call{value: msg.value}("");
        require(success, "call failed");
    }

}

// ETH 수신 불가
contract Lec24_NoReceiveAndFallback {}

// ETH 수신 가능 (send, transfer, call)
// receive 함수에서 이벤트 발생
contract Lec24_ReceiveWithEvent {
    event Received(address sender, uint256 amount);

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
}

// ETH 수신 가능 (call만 가능)
// receive 함수에서 상태 변수 변경 (2300 gas로는 상태 변수 변경 불가)
contract Lec24_ReceiveWithStorage {
    uint256 public balance;

    receive() external payable {
        balance += msg.value; // 2300 gas 부족
    }
}

// ETH 수신 가능 (fallback으로 ETH 수신 처리)
contract Lec24_OnlyFallback {
    event FallbackCalled(address sender, uint256 amount);

    fallback() external payable {
        emit FallbackCalled(msg.sender, msg.value);
    }
}

// ETH 수신 불가
// fallback 함수에 payable이 없어서 ETH 수신 불가
// Lec24_NoPayableFallback 컨트랙트에 존재하지 않는 함수 호출 시 fallback 함수 실행
contract Lec24_NoPayableFallback {
    event FallbackCalled(address sender);

    fallback() external {
        emit FallbackCalled(msg.sender);
    }
}

// ETH 수신 가능
// receive 함수로 ETH 수신 처리
// fallback 함수에 payable이 있지만, receive 함수로 ETH 수신 처리
contract Lec24_ReceiveAndFallback {

    event FromReceive(address sender, uint256 amount);
    event FromFallback(address sender, uint256 amount);

    receive() external payable {
        emit FromReceive(msg.sender, msg.value);
    }

    fallback() external payable {
        emit FromFallback(msg.sender, msg.value);
    }
}

