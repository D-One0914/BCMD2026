// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "hardhat/console.sol";

/*
    if 조건문 (If condition)
    - 주어진 조건이 true일 때만 특정 코드를 실행하는 제어문이다.
    - 조건은 비교 연산자(==, !=, >, < 등)를 통해 작성한다.
    - 조건이 false일 경우 해당 코드는 실행되지 않는다.
    - else, else if를 함께 사용하여 여러 조건을 분기할 수 있다.
*/

contract Lec10_If_Condition {

    function classifyAge(uint256 _age) public pure {

        if (_age < 5) { // 0 ~ 4
            console.log("Age is between 0 and 4");
        } else if (_age >= 5 && _age < 10) {  // 5 ~ 9
            console.log("Age is between 5 and 9");
        } else if (_age == 99) { // 99
            console.log("Age is exactly 99");
        } else { //10 이상
            if(_age == 15) {
                console.log("Age is exactly 15");
            }
            console.log("Age is 10 or greater");
        }
    }

}
