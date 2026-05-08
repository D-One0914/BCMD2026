// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/*

Lec16 ~ Lec20 학습 내용을 바탕으로 작성하는 실습입니다.

Practice03_Vault.sol

1. owner 상태 변수를 작성하세요.
    - address public owner 타입입니다.
    - 현재 컨트랙트의 관리자 주소를 저장합니다.

2. 생성자(constructor) 함수를 작성하세요.
    - 컨트랙트를 배포한 주소(msg.sender)를 owner에 저장하세요.

3. 아래 커스텀 에러를 작성하세요.
    - error OnlyOwner();
    - error TransferFailed();

    - OnlyOwner: owner가 아닌 주소가 호출한 경우 사용합니다.
    - TransferFailed: ETH 전송에 실패한 경우 사용합니다.

4. onlyOwner modifier를 작성하세요.
    - owner가 아닌 경우 OnlyOwner 에러를 발생시키세요.

5. receive 함수를 작성하세요.
    - 컨트랙트가 ETH를 받을 수 있도록 작성하세요.

6. getBalance 함수를 작성하세요.
    - 현재 컨트랙트에 저장된 ETH 잔액을 반환하세요.
    - address(this).balance를 사용하세요.

7. withdraw 함수를 작성하세요.
    - receiver 주소를 입력받으세요.
    - onlyOwner modifier를 적용하세요.
    - 컨트랙트에 있는 모든 ETH를 receiver로 전송하세요.
    - call 함수를 사용하세요.
      예: (bool success, ) = receiver.call{value: address(this).balance}("");
    - 전송 실패 시 TransferFailed 에러를 발생시키세요.
*/

contract Vault {
    address public owner;

    error OnlyOwner();
    error TransferFailed();

    modifier onlyOwner() {
        // TODO: msg.sender가 owner가 아닌 경우 OnlyOwner 에러 발생
        _;
    }

    constructor() {
        // TODO: owner를 msg.sender로 설정
    }

    // TODO: receive() external payable 함수 작성 (ETH를 받을 수 있도록)

    function withdraw(address payable receiver) external onlyOwner {
        // TODO: 컨트랙트의 모든 ETH를 receiver로 전송하세요.
        // (bool success, ) = receiver.call{value: address(this).balance}("");
        // TODO: 전송 실패 시 TransferFailed 에러 발생
    }

    function getBalance() external view returns (uint256) {
        // TODO: address(this).balance 반환
    }
}
