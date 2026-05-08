// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    Abstract
    - 하나 이상의 함수가 구현되지 않은(미완성) 컨트랙트이다.
    - 직접 배포할 수 없고, 반드시 상속을 통해 구현해야 한다.
    - 공통 로직을 정의하면서, 일부 기능은 자식 컨트랙트에 구현을 강제할 때 사용한다.
    - 구현되지 않은 함수는 virtual 키워드를 사용한다.
    - 자식 컨트랙트에서는 override를 통해 반드시 재정의해야 한다.

    Interface
    - 구현 없이 함수 구조를 정의한 인터페이스이다.
    - function, event, error, struct, enum 선언 가능하다.
    - 여러 컨트랙트가 동일한 구조를 따르도록 강제하는 데 사용한다.
    - 직접 배포가 불가하고, 반드시 상속을 통해 구현해야한다.
    - 함수 선언시 external을 사용하며, 구현부가 없다.
    - 함수 선언시 자동적으로 virtual이 지정되므로 따로 붙이지 않아도 된다. 
    - 상태 변수, constructor를 가질 수 없다.
    - 또 하나의 주요 기능은 외부 컨트랙트와 상호작용하기 위해 사용한다.

*/


abstract contract Animal {
    
    // 상태 변수
    string public name;

    // 생성자
    constructor(string memory _name) {
        name = _name;
    }

    // 함수 (공통로직)
    function move() public pure returns (string memory) {
        return "move";
    }

    // 추상 함수 (자식 컨트랙트에서 반드시 구현)
    function sound() public pure virtual returns (string memory);
}


interface IAnimal {
    
    // interface: function, event, error, struct, enum 선언 가능

    // 상태 변수 - 컴파일 에러
    // string public name;

    // 생성자 불가능 - 컴파일 에러
    // constructor(string memory _name) {
    //     name = _name;
    // }

    // 함수 (공통로직) 불가능 - 컴파일 에러
    // function move() public pure returns (string memory) {
    //     return "move";
    // }

    // 추상 함수 (자식 컨트랙트에서 반드시 구현) 
    // virtual을 따로 명시하지 않아도 자동적으로 지정된다.
    function sound() external returns (string memory);
}

contract Lec21_AbstractDog is Animal {

    constructor(string memory _name) Animal(_name) {

    }

    function sound() public pure override returns (string memory) {
        return "woof woof";
    }
}

contract Lec21_InterfaceDog is IAnimal {

    function sound() external pure override returns (string memory) {
        return "woof woof";
    }
}

