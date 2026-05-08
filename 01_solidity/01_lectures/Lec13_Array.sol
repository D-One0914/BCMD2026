// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    배열(Array) 
    - 같은 데이터 타입을 연속적으로 저장하는 자료구조이다.
    - 길이에 따라 고정 배열과 동적 배열로 나뉜다.

    배열 생성법 

    1. 고정 배열
     - 고정 배열은 선언시 길이가 고정된다.
     - 길이가 고정되므로 줄이거나 늘릴수 없다.
     - 스토리지 슬롯에 고정된 배열크기로 연속적으로 저장된다.

     - uint256[3] public fixedArr; // 길이가 3인 고정 배열 생성 (스토리지 슬롯 3개 차지) 
     - fixedArr[0] = 10; // 배열의 첫 번째 요소에 10 저장
     - fixedArr[1] = 20; // 배열의 두 번째 요소에 20 저장
     - fixedArr[2] = 30; // 배열의 세 번째 요소에 30 저장
     
    고정 배열의 멤버 함수/속성
     - fixedArr.length // 고정 배열의 길이 확인
     - delete fixedArr[0] // 고정 배열의 첫 번째 요소 삭제, 길이는 그대로 값이 0이 된다.
     - fixedArr[0] = 20 // 고정 배열의 첫 번째 요소에 20 저장

    2. 동적 배열 
     - 동적 배열은 길이가 고정되지 않으므로, 스토리지 슬롯에 길이가 저장되며, 주소 keccak256(slot)를 통해 데이터를 접근한다.
     - uint256[] public dynamicArr
     
    동적 배열의 멤버 함수/속성
    - dynamicArr.length // 동적 배열의 길이 확인
    - dynamicArr.push(10) // 동적 배열의 끝에 10 추가되며, 길이가 증가한다.
    - dynamicArr.pop() // 동적 배열의 끝 요소 제거되며, 길이가 감소한다.
    - delete dynamicArr[0] // 동적 배열의 첫 번째 요소 삭제, 길이는 그대로 값이 0이 된다.
    - dynamicArr[0] = 20 // 동적 배열 첫 번째 요소에 20 저장

*/

contract Lec13_FixedArray {

    uint256[3] public fixedArr; // 기본값 [0,0,0] 초기화 
    uint256[3] public fixedArr2 = [1,2,3];

    // 전체 값 수정
    function update() public {
        fixedArr = [4,5,6];
    }

    // 인덱스 접근 후 값 수정
    function setValue() public {
        fixedArr2[0] = 10; // 0번째 인덱스 접근 후 값 변경 (1 -> 10)
        fixedArr2[1] = 20; // 1번째 인덱스 접근 후 값 변경 (2 -> 20)
        fixedArr2[2] = 30; // 2번째 인덱스 접근 후 값 변경 (3 -> 30)
    }

    // 배열 길이 확인
    function getLength() public view returns (uint256) {
        return fixedArr.length; // uint256[3]로 선언했으므로, 항상 길이는 3
    }

    // 인덱스 접근 후 값 삭제 (초기화)
    function remove() public {
        delete fixedArr[0]; // 0번째 인덱스 접근 후 삭제 (1 -> 0)
    }
}


contract Lec13_DynamicArrayExample {

    uint256[] public dynamicArr; // 기본값 [] 초기화, 길이는 0 
    uint256[] public dynamicArr2 = [1,2,3]; // [1,2,3]이 할당되어서 초기 길이는 3

    // push로 값 추가, 길이 증가
    function pushValue() public {
        dynamicArr.push(1);
        dynamicArr.push(2);
        dynamicArr.push(3);
    }

    // 인덱스 접근 후 값 수정
    function setValue() public {
        dynamicArr2[0] = 10;
        dynamicArr2[1] = 20;
        dynamicArr2[2] = 30;
    }

    // 인덱스 접근 후 값 삭제 (초기화), 길이 그대로
    function removeValue() public {
        delete dynamicArr[0]; // 0번째 인덱스 접근 후 삭제 (1 -> 0)
    }

    // 마지막 제거, 길이 감소
    function popValue() public {
        dynamicArr.pop(); // 길이 감소, 마지막 요소 제거 ([1,2,3] -> [1,2]) 
    }

    // 배열 길이 확인
    function getLength() public view returns (uint256) {
        return dynamicArr.length;
    }
}

