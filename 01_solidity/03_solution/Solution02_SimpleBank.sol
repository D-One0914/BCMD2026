// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/*

Lec10 ~ Lec15 학습 내용을 바탕으로 작성하는 실습입니다.

SimpleBank 

1. User 구조체를 작성하세요.
    - name (string)
    - age (uint256)
    - balance (uint256)

2. 아래 상태 변수를 작성하세요.
    - mapping(address => User) private users;
    - 각 주소에 해당하는 User 정보를 저장합니다.

3. register 함수를 작성하세요.
    - name과 age를 입력받아 저장하세요.
    - balance는 0으로 초기화하세요.

4. deposit 함수를 작성하세요.
    - 입력받은 amount 만큼 자신의 balance를 증가시키세요.

5. withdraw 함수를 작성하세요.
    - 입력받은 amount 만큼 자신의 balance를 감소시키세요.

6. getMyInfo 함수를 작성하세요.
    - 자신의 User 정보를 반환하세요.
*/

contract SimpleBank {
    struct User {
        string name;
        uint256 age;
        uint256 balance;
    }

    mapping(address userAddress => User userData) private users;

    function register(string calldata _name, uint256 _age) external {
        users[msg.sender] = User({name: _name, age: _age, balance: 0});
    }

    function deposit(uint256 _amount) external {
        users[msg.sender].balance += _amount; // balance = balance - _amount;
    }

    function withdraw(uint256 _amount) external {
        users[msg.sender].balance -= _amount; // balance = balance + _amount;
    }

    function getMyInfo() external view returns (User memory) {
        return users[msg.sender];
    }
}
