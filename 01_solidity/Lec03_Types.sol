// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/*
    자료형 (Data Type)
    - 프로그램에서 사용하는 값의 종류를 정의하는 개념이다.
    - 자료형은 크게 값 타입과 참조 타입으로 구분된다. 

    값 타입 (Value Type)
    - 값 자체를 저장한다.
    - 값을 다른 변수에 대입시, 값이 복사되어 서로 완전히 독립된 값이 된다.
    
    - int8, int16, int32, int64, int128, int256(=int) 
    - uint8, uint16, uint32, uint64, uint128, uint256(=uint)
    - bytes1 ~ bytes32
    - address
    - bool
    - enum

    값 타입 기본값

    - int8 ~ int256  : 0
    - uint8 ~ uint256: 0
    - bytes1 ~ bytes32: 0x00 (bytes1), 0x0000(bytes2) ... (해당 크기만큼 0으로 채워짐)
    - address        : address(0) = 0x0000000000000000000000000000000000000000
    - bool           : false
    - enum           : 첫 번째 항목 (index 0)


    참조 타입 (Reference Type)
    - 값의 위치(주소) 기반으로 저장한다.
    - 영역에 따라 값을 다른 변수에 대입시, 값이 복사 또는 참조된다. 
    
    - 같은 영역이면 값 대입시 참조되므로, 원본과 동일한 값을 참조한다.
        storage → storage : 참조
        memory  → memory  : 참조
    
    - 다른 영역이면 값 대입시 복사되므로, 원본과 완전히 독립된 동일한 값이 된다.
        storage → memory  : 복사
        memory  → storage : 복사
        calldata → memory : 복사

    - array
    - mapping
    - struct
    - string
    - bytes
   
    참조 타입 기본값

    - array   : 빈 배열 [] (length = 0)
    - mapping : 모든 key의 value가 해당 타입의 기본값
    - struct  : 각 필드가 해당 타입의 기본값
    - string  : "" (빈 문자열)
    - bytes   : "" (빈 바이트)
*/

contract Lec03_Types {
    
    // int(음수 포함) Vs uint(음수 안 포함)
    int8 public int8Value = -128; // int8 : -128 ~ 127 (= -2^7 ~ 2^7-1)
    int256 public int256Value = -129; // -129 (범위: -2^255 ~ 2^255-1)

    uint8 public uint8Value = 255; // uint8 : 0 ~ 255 (= 0 ~ 2^8-1)
    uint256 public uint256Value = 256; // uint256 : 0 ~ 2^256-1

    bytes1 public bytes1Value = 0x12; 
    bytes32 public bytes32Value = "hello"; // 32바이트로 고정

    bool public boolValue = true; // true or false

    address public addressValue = 0xd9145CCE52D386f254917e481eB44e9943F39138;

    bytes public bytesValue = "hello";
    string public stringValue = "hello"; 
   
}
