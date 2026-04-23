// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/*
    변수 (Variable)
    - 데이터를 저장하기 위해 사용하는 공간이다. 
    - 변수는 동일한 타입 (자료형) 내에서 값 변경이 가능하다.

    변수 작성법
    uint256 public age = 20;
    자료형 가시성 지정자 변수명 = 값;

    상수 (Constant)
    - 데이터를 저장하기 위해 사용하는 공간이다. 
    - 한번 저장된 값은 변경이 불가능하다.

    상수 키워드
    constant 
    - 상수 선언시 값을 할당해야한다.
    - 컴파일 시 값이 결정된다.

    immutable
    - 선언 시 값을 할당하지 않고, constructor(생성자 함수)에서 단 한 번 값을 설정한다.
    - 이후 변경이 불가능하다.

    상수 작성법
    constant
    uint256 public constant age = 20;
    자료형 가시성 지정자 상수 키워드 변수명 = 값;

    immutable
    uint256 public immutable age;

*/

contract Lec02_Variables_Constants {

    // constant (컴파일 시 고정)
    uint256 public constant CONSTANT_VALUE = 22;

    // immutable (배포 시 1회 설정)
    uint256 public immutable immutableValue;

    // 일반 상태 변수
    uint256 public defaultAge = 20;

    constructor() {
        immutableValue = 3;
    }
}






