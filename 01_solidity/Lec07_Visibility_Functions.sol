// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

/*
    가시성 지정자(Visibility)
 
    - 가시성 지정자는 상태 변수와 함수의 접근 범위를 결정한다.
    - 변수와 함수에 적용할 수 있다.
    - 범위에 따라 총 4가지로 구분된다.

    1.public
    - 외부 및 내부에서 모두 접근 가능하다.
    - 상속받은 컨트랙트 내부에서 접근 가능하다.
    - 상태 변수에 적용할 경우, 해당 변수 값을 조회할 수 있는 getter 함수가 자동으로 생성된다.

    2.external
    - 외부에서만 호출 가능하다.
    - 같은 컨트랙트 내부에서는 직접 호출할 수 없으며,
    - this.함수명() 형태로 외부 호출 방식으로만 접근 가능하다.

    3.internal
    - 현재 컨트랙트 및 상속받은 컨트랙트 내부에서만 접근 가능하다.
    - 외부에서는 호출할 수 없다.

    4. private
    - 현재 컨트랙트 내부에서만 접근 가능하다.
    - 상속받은 컨트랙트에서도 접근할 수 없다.


    함수 (Function)

    - 함수는 컨트랙트 내에 정의된 기능으로, 특정 작업을 수행한다.
    - 함수는 입력값(parameter)을 받아 결과값을 반환할 수 있다.
    - 함수는 상태 변수의 값을 변경할 수도 있다.

    
    function 함수명() [public | external | internal | private] [pure | view | payable | 없음] [returns()] {
        ...
    }
    
    함수 상태 지정자 (Function State Mutability)

    pure
    - 상태 변수를 읽지도 않고 수정하지도 않는다.
    - 순수하게 함수 내부의 로직과 입력값만을 사용한다.

    view 
    - 상태 변수를 읽을 수는 있지만 수정할 수 없다.
    - 조회 함수로 쓰이며, view 함수는 주로 call로 호출하여 가스비 없이 사용 가능하다.

    payable
    - 함수와 변수에 적용가능
    - 함수: 실행 시 ETH(네이티브 코인)를 함께 받을 수 있음 (msg.value 사용)
    - 변수(address payable): ETH를 받을 수 있는 주소 타입 
  
    없음
     - 상태 변수를 읽고 수정할 수 있다.

    생성자 (Constructor)
    - 스마트 컨트랙트가 배포(deploy)될 때 단 한 번 실행되는 함수이다.
    - 컨트랙트의 초기 상태를 설정하는 데 사용된다.
    
*/

// 가시성 지정자 - 변수
contract Lec07_Example_1 {
    uint256 public publicValue = 123; // public: 스마트 컨트랙트 내부 및 외부에서 접근 가능, getter 함수 자동 생성
    uint256 internal internalValue = 1234; // internal: 현재 컨트랙트 및 상속받은 컨트랙트 내부에서만 접근 가능
    uint256 internalValue2 = 1234; // internal: internal이 생략되었지만, 기본적으로 internal로 적용
    uint256 private privateValue = 456; // private: 현재 컨트랙트 내부에서만 접근 가능, 상속받은 컨트랙트에서도 접근 불가
    // uint256 external externalValue =1; // external: 외부에서만 호출 가능, 내부접근이 불가능하므로 컴파일 오류
}

// 가시성 지정자 - 함수
contract Lec07_Example_2 {

    // external: 스마트 컨트랙트 외부에서만 호출 가능, 
    // 스마트 컨트랙트 내부접근이 불가능 단 
    // this.함수명() 형태로 외부접근으로 호출 가능
    function externalFunction() external pure returns (uint256) {
        return 1;
    }

    // public: 스마트 컨트랙트 내부 및 외부에서 호출 가능
    function publicFunction() public pure returns (uint256) {
        return 2;
    }

    // internal: 스마트 컨트랙트 내부 및 상속받은 컨트랙트 내부에서만 호출 가능
    function internalFunction() internal pure returns (uint256) {
        return 2;
    }

    // private: 스마트 컨트랙트 내부에서만 호출 가능
    function privateFunction() private pure returns (uint256) {
        return 4;
    }

    function callFunctions() external view returns (uint256, uint256, uint256, uint256) {
        // uint256 callExternal = externalFunction(); // external 함수는 내부접근이 불가능하므로 컴파일 오류
        uint256 callExternal = this.externalFunction(); // this를 통해 외부접근으로 함수 호출
        uint256 callPublic = publicFunction();
        uint256 callInternal = internalFunction();
        uint256 callPrivate = privateFunction(); 
        return (callExternal, callPublic, callInternal, callPrivate);
    }
}

// 상태 지정자 - view, 없음, pure

contract Lec07_Example_3 {

    // 상태 변수
    uint256 value; // 값이 할당되지 않았으므로, 0으로 기본 초기화 

    // view 함수: 상태 변수 접근시 읽기전용, 상태 변수의 값을 조회할 때 사용
    // view 함수는 주로 call로 호출하여 가스비 없이 사용 가능 
    function getValue() public view returns (uint256) {
        return value; 
    }

    // 상태 지정자 없음 : 상태 변수에 접근하여 읽고 수정 가능
    // 상태 변수를 변경하는 함수는 트랜잭션을 발생시키므로 가스비가 발생
    function setValue(uint256 _value) public {
        value = _value; 
    }

    // pure 함수: 상태 변수에 접근하지 않고, 입력값만을 사용하여 결과를 반환하는 함수
    // pure 함수는 주로 call로 호출하여 가스비 없이 사용 가능
    function add(uint256 _number1, uint256 _number2) public pure returns (uint256) {
        return _number1 + _number2; 
    }

}

// 입력값(parameter)과 반환값 (return value)
contract Lec07_Example_4 {

    string public text = "Hi";


     // 참조 타입은 함수 입력시 memory 또는 calldata로 지정
    function setText(string memory _text) public {
        _text = "Hello"; // memory는 읽고 쓰기가 가능
        text = _text;
    }

    function setText2(string calldata _text) public {
        //_text = "Hello"; // calldata는 읽기전용(read-only)이므로 변경불가, 컴파일 오류
        text = _text;
    }
    
    // 참조 타입은 반환시 memory로 지정
    function getText() public view returns (string memory) {
        return text;
    }
    
    // 여러 개의 타입이 다른 반환값 가능
    function getReturns() public pure returns (string memory, uint256) {
        return ("Alice", 30);
    }

    // 반환값에 이름을 붙여서 반환 가능하며, 이때 return 키워드 생략 가능
    function getReturns2() public pure returns (string memory name, uint256 age) {
        name = "Alice";
        age = 30;
    }




}



















contract Lec07_Visibility_Functions {

    uint256 public init = 55; 

    uint256 public publicValue = 123;
    uint256 internal internalValue = 1234;
    uint256 intervalue2 = 1234;
    uint256 private privateValue = 456;
    // uint256 external externalValue =1; // 내부접근이 불가능하므로 컴파일 오류
    string public publicString = "";
   
    constructor() {
        init = 99;
    }

    function externalFunction() external {
        publicValue = 1234567;
    }

    function externalViewFunction() external view returns (uint256) {
        return publicValue;
    }

    function publicViewFunction() public view returns (uint256) {
        return publicValue;
    }

    function publicPureFunction(uint256 _a, uint256 _b) public pure returns (uint256) {
        return _a + _b;
    }

    function internalPureFunction() internal pure returns (uint256) {
        return 5;
    } 

    function getTotalValue() external view returns (uint256) {
        // uint256 callExteneralFunction = externalViewFunction(); // 내부접근이 불가능하므로 컴파일 오류
        uint256 callExteneralFunction = this.externalViewFunction(); // this를 통해 외부접근으로 함수 호출
        uint256 callPublicFunction = publicViewFunction();
        uint256 callInternalFunction = internalPureFunction();
        uint256 result = callExteneralFunction + callPublicFunction + callInternalFunction;
        return result;
    }

    function getTotalValueNamed() external view returns (uint256 result) {
        uint256 callExteneralFunction = this.externalViewFunction();
        uint256 callPublicFunction = publicViewFunction();
        uint256 callInternalFunction = internalPureFunction();
        result = callExteneralFunction + callPublicFunction + callInternalFunction;
    }

    function getTwoRetunrs() external pure returns (uint256, int256) {
        return (12, -12);
    }

    function getTwoRetunrsNamed() external pure returns (uint256 postive, int256 negative) {
        postive = 12;
        negative = -12;
    }

    function memoryName(string memory _name1) public {
        _name1 = "AAA";
        publicString = _name1;
    }

    function calldataName(string calldata _name1) public {
        //_name1 = "BBB"; // calldata는 읽기전용(read-only)이므로 변경불가
        publicString = _name1;
    }

}