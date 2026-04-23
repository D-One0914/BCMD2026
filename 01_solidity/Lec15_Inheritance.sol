// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";
/*
    상속 (Inheritance)
    - 특정 컨트랙트(부모)의 상태 변수와 함수들을 다른 컨트랙트(자식)가 물려받아 재사용할 수 있도록 하는 기능이다.
    - 이를 통해 코드의 재사용성과 확장성을 높일 수 있다.
    - 부모 컨트랙트의 public / internal 함수와 변수는 상속된다.
    - 부모 컨트랙트의 private 변수와 함수는 상속되지 않는다.

    상속 사용법
    - is 키워드를 사용하여 부모 컨트랙트를 상속받는다
    - contract B is A {}

    함수 오버라이딩 (Overriding)
    - 부모의 함수를 자식에서 재정의할 수 있다
    - 부모의 함수는 virtual 키워드가 필요하다
    - 자식의 함수는 override 키워드를 사용해야 한다


    function foo() public virtual {}
    function foo() public override {}

    super 키워드
    - 부모 컨트랙트의 함수를 호출할 때 사용
    - super.foo();

    다중 상속 (Multiple Inheritance)
    - 여러 컨트랙트를 동시에 상속받을 수 있다
    - contract C is A, B {}
    
    - 상속 순서에 따라 실행 순서가 결정된다 

    생성자 실행 순서
    - 부모 컨트랙트의 생성자가 먼저 실행되고, 이후 자식 생성자가 실행된다 ( A -> B -> C)

    함수 상속 순서
    - 같은 함수를 상속 받고 super를 통해 부모 함수를 그대로 받아 들일때 실행 순서는 상속 순서의 역순이다 ( C -> B -> A )

*/



contract Lec15_Father{

    // 상태 변수
    uint256 public fatherBalance = 100; // public은 상속 가능
    uint256 internal internalValue = 77; // internal은 상속 가능, 외부에서는 접근 불가능
    uint256 private privateValue = 5; // private은 상속 불가능
    
    string public name; 

    constructor(string memory _name) {
        name = _name;
        console.log("Father constructor called");
    }

    function getFamilyName() public pure returns(string memory) {
        return "Kim";
    }
    
    function getBalance() public view virtual returns(uint256){
        return fatherBalance;
    }
    
}

contract Lec15_Mother {
    uint256 public motherBalance = 500;
    
    constructor() {
        console.log("Mother constructor called");
    }

    function getFamilyName() public pure returns(string memory) {
        return "Lee";
    }

    function getBalance() public view virtual returns(uint256){
        return motherBalance;
    }
}


// 단일 상속
contract Lec15_Son is Lec15_Father {

    // 생성자 순서 : Father -> Son
    constructor(string memory _name) Lec15_Father(_name) {
        console.log("Son constructor called");
    }

    function getBalance() public view override returns(uint256) {
        return fatherBalance; // Father의 getBalance 오버라이딩
    }
}

// 다중 상속
contract Lec15_Son2 is Lec15_Mother, Lec15_Father {

    // 생성자 순서 : Mother -> Father -> Son
    constructor(string memory _name) Lec15_Father(_name) {
        console.log("Son constructor called");
    }

    // 다중 오버라이딩
    // 상속 받은 변수를 이용해 오버라이딩
    function getBalance() public view override(Lec15_Mother, Lec15_Father) returns(uint256) {
        return fatherBalance + motherBalance + 1000;
    }

    // super 키워드를 이용해 부모 함수 호출
    // 함수 호출시 Son -> Father -> Mother 순으로 호출되며, Father의 getFamilyName이 호출
    function getFatherFamilyName() public view override returns(string memory) {
        return super.getFamilyName(); // Kim이 반환됨
    }
}
















contract Lec15_Son2 is Lec15_Father, Lec15_Mother {

    constructor() Lec15_Father("Jhon2") {}

    function getBalance() public view override(Lec15_Father, Lec15_Mother) returns(uint256) {
        return fatherBalance + motherBalance;
    }
}

contract Lec15_Son3 is Lec15_Father, Lec15_Mother {
    constructor(string memory _name) Lec15_Father(_name) {}

    function getBalance() public view override(Lec15_Father, Lec15_Mother) returns(uint256) {
        return super.getBalance(); // Mother의 getBalance 호출
    }

}