// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    Library

    - 재사용 가능한 함수들을 모아놓은 컨트랙트이다.
    - 상태 변수를 가질 수 없다.
    - 상속이 아닌 using for 또는 직접 호출을 통해 사용한다.
    - 동일한 로직을 여러 컨트랙트에서 재사용할 때 사용한다.
    - 코드 중복을 줄이고 gas 비용을 절약하는 데 도움을 준다.

*/

library MathLib {
    function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
        return _a + _b;
    }

    function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
        return _a - _b;
    }
}

// using for을 이용한 라이브러리 사용
contract Lec20_Calculator {

    // uint256 타입에 MathLib 함수 붙이기
    using MathLib for uint256;

    function add(uint256 _num1, uint256 _num2) external pure returns (uint256) {
        return _num1.add(_num2);
    }

    function sub(uint256 _num1, uint256 _num2) external pure returns (uint256) {
        return _num1.sub(_num2);
    }

}

// 직접 호출을 이용한 라이브러리 사용
contract Lec20_Calculator2 {

    function add(uint256 _num1, uint256 _num2) public pure returns (uint256) {
        return MathLib.add(_num1, _num2);
    }

    function sub(uint256 _num1, uint256 _num2) external pure returns (uint256) {
        return MathLib.sub(_num1, _num2);
    }
}