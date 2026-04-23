// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    컨트랙트 인스턴스(Instance) 생성

    - 인스턴스란 새로운 스마트 컨트랙트를 생성(배포)한 것을 의미한다.
    - 각 인스턴스는 서로 다른 주소(address)를 가진다.
    - 컨트랙트 인스턴스를 생성할 때는 new 키워드를 사용한다.
    - new는 새로운 컨트랙트를 블록체인에 배포하고, 해당 컨트랙트의 주소를 반환한다.
    - new를 사용한 컨트랙트 생성은 많은 gas 비용이 발생한다.

 */

contract Lec19_Box {
    uint256 public value;

    constructor(uint256 _value) {
        value = _value;
    }

    function getAddress() public view returns (address) {
        return address(this);
    }
}

contract Lec19_BoxFactory {
    
    function create(uint256 _value) public returns (address) {
        // Lec19_Box 컨트랙트의 새로운 인스턴스를 생성하고(배포), 해당 인스턴스의 주소를 반환
        Lec19_Box newBox = new Lec19_Box(_value);
        return address(newBox);
    }
}