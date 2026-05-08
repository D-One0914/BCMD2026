// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/*

Lec16 ~ Lec20 학습 내용을 바탕으로 작성하는 실습입니다.

Practice04_Sale.sol

SaleWithVault 컨트랙트는 buy 함수를 통해 ETH를 받고,
받은 ETH를 Vault 컨트랙트에 보관하는 스마트 컨트랙트입니다.

1. IVault 인터페이스를 작성하세요.
    - getBalance() external view returns (uint256) 함수를 선언하세요.
    - Vault에 보관된 ETH 잔액을 조회하기 위해 사용합니다.

2. vault 상태 변수를 작성하세요.
    - IVault 타입입니다.
    - immutable로 선언하세요.

3. constructor를 작성하세요.
    - Vault 컨트랙트 주소를 입력받아 vault 변수에 저장하세요.

4. Purchased 이벤트를 작성하세요.
    - event Purchased(address indexed buyer, uint256 amount);
    - buy 함수가 성공적으로 실행되면 이벤트를 발생시키세요.

5. 아래 커스텀 에러를 작성하세요.
    - error AlreadyPurchased();
    - error TransferFailed();

    - AlreadyPurchased: 이미 구매한 주소가 다시 구매하려는 경우 사용합니다.
    - TransferFailed: ETH 전송에 실패한 경우 사용합니다.

6. hasPurchased 상태 변수를 작성하세요.
    - mapping(address => bool) 타입입니다.
    - 각 주소의 구매 여부를 저장합니다.

7. buy 함수를 작성하세요.
    - payable로 작성하세요.
    - 이미 구매한 사용자인 경우 AlreadyPurchased 에러를 발생시키세요.
    - 구매 처리 후 hasPurchased를 true로 변경하세요.
    - 받은 ETH를 Vault로 전송하세요.
      예: address(vault).call{value: msg.value}("");
    - 전송 실패 시 TransferFailed 에러를 발생시키세요.
    - Purchased 이벤트를 발생시키세요.

8. getVaultBalance 함수를 작성하세요.
    - Vault의 getBalance()를 호출하여 반환하세요.

*/

interface IVault {
    function getBalance() external view returns (uint256);
}

contract Sale {
    IVault public immutable vault;

    mapping(address => bool) public hasPurchased;

    event Purchased(address indexed buyer, uint256 amount);

    error AlreadyPurchased();
    error TransferFailed();

    constructor(IVault _vault) {
        // TODO: vault 변수에 _vault 저장
    }

    function buy() external payable {
        // TODO: 이미 구매한 주소라면 AlreadyPurchased 에러 발생

        // TODO: 구매 여부를 true로 변경

        // TODO: 받은 ETH를 Vault 컨트랙트로 전송
        // 힌트: address(vault).call{value: msg.value}("");

        // TODO: 전송 실패 시 TransferFailed 에러 발생

        // TODO: Purchased 이벤트 발생
    }

    function getVaultBalance() external view returns (uint256) {
        // TODO: Vault의 getBalance() 호출 결과 반환
    }
}