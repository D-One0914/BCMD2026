// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/*

Lec01 ~ Lec09 학습 내용을 기반으로 진행하는 실습입니다.

SimpleStorage 

1. name과 age 상태 변수를 작성하세요.
    - name은 string 타입입니다.
    - age는 uint256 타입입니다.
    - 각 변수는 public 가시성 지정자를 가집니다.

2. 생성자(constructor) 함수를 작성하세요.
    - name과 age를 입력받아 상태 변수에 저장하세요.

3. setAge 함수를 작성하세요.
    - 입력받은 값을 age에 저장하세요.

4. setName 함수를 작성하세요.
    - 입력받은 값을 name에 저장하세요.

5. getProfile 함수를 작성하세요.
    - 저장된 name과 age를 함께 반환하세요.

*/

contract SimpleStorage {
    string public name;
    uint256 public age;

    constructor(string memory _name, uint256 _age) {
        // TODO: name 설정
        // TODO: age 설정
    }

    function setAge(uint256 _age) external {
        // TODO: age 설정
    }

    function setName(string calldata _name) external {
        // TODO: name 설정
    }

    function getProfile() external view returns (string memory, uint256) {
        // TODO: name과 age를 함께 반환
    }
}
