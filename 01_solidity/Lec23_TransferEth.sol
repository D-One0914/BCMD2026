// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    Payable
    
    - payable은 ETH를 주고받기 위해 필요한 키워드이다.
    - ETH를 받는 함수(생성자 포함) 또는 주소에는 반드시 payable이 필요하며, 없을시 ETH 전송 시 에러가 발생한다.
    
    msg.value
    
    - msg.value는 트랜잭션과 함께 전송된 ETH의 양을 의미한다.
    - 단위는 wei이다.
    
    address(this).balance  
    
    - 현재 컨트랙트에 저장된 ETH의 양을 의미한다.
    - 단위는 wei이다.
    
    ETH 전송 방법
    
    1. send
    - 수신 컨트랙트의 fallback/receive 함수에 최대 2300 gas만 전달해 실행되도록 한다. 
    - 즉 수신 컨트랙트의 fallback/receive 함수가 실행할 수 있는 gas를 최대 2300으로 제한한다.
    - 실패 시 트랜잭션은 revert되지 않고 false를 반환한다.
    - 전송이 실패하면 ETH는 전송되지 않으며, 현재 컨트랙트(address(this))에 그대로 남는다.
    
    2. transfer
    - 수신 컨트랙트의 fallback/receive 함수에 최대 2300 gas만 전달해 실행되도록 한다. 
    - 즉 수신 컨트랙트의 fallback/receive 함수가 실행할 수 있는 gas를 최대 2300으로 제한한다.
    - 실패 시 자동으로 revert된다.
    
    3. call 
    - 전달할 gas를 조절할 수 있으며, 별도로 지정하지 않으면 대부분의 남은 gas가 전달된다.
    - 실패 시 (bool, bytes) 형태로 결과를 반환한다.
    - 현재 가장 많이 사용되는 방식이다.
    - call 사용 시 reentrancy(재진입) 공격에 주의해야 하며, Checks-Effects-Interactions 패턴 또는 ReentrancyGuard 사용 해야한다. 
    
    왜 call을 사용하는가? 
    - 과거에는 opcode의 비용이 현재에 비해 낮아서, transfer/send의 2300 gas 제한으로도 충분히 fallback/receive의 함수 실행 가능했다.  
    - 그러나, EVM 업데이트(EIP-1884, EIP-2929 등)로 인해 일부 opcode 비용이 증가하면서, 2300 gas로는 일부 컨트랙트가 더 이상 정상 실행되지 않는 경우가 발생하였다.
    - 이로인해 call 방식을 채택하고 있다. 
 */

contract Lec23_TransferEth {

    // 스마트 컨트랙트 배포시 ETH 수신 가능
    constructor() payable {

    }

    function getBalance() external view returns(uint256) {
        return address(this).balance;
    }
    
    function sendWithSend(address _receiver) external payable {
        // send/transfer의 경우 보내고자 하는 주소에 payable을 붙여야 함.
        bool success = payable(_receiver).send(msg.value);
        require(success, "send failed");
    }

    function sendWithTransfer(address _receiver) external payable {
        // send/transfer의 경우 보내고자 하는 주소에 payable을 붙여야 함.
        payable(_receiver).transfer(msg.value);
    }

    function sendWithCall(address _receiver) external payable {
       (bool success,) = _receiver.call{value: msg.value}("");
       require(success, "send failed");
    }

}

