// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "hardhat/console.sol";
/*
    반복문 (Loop)

    - 배열이나 특정 조건을 기반으로 코드를 반복 실행할 때 사용한다.
    - Solidity에서는 for, while, do-while 세 가지 반복문을 제공한다.
    - 반목문은 가스 비용이 많이 들 수 있으며, 실무에서는 반복문 사용을 자제한다.  

    1. for문
    - 초기값, 조건, 증감식을 한 줄에 작성한다.

    2. while문
    - 조건이 참인 동안 계속 반복이 가능하다.
    - 조건 설정을 잘못하면 무한 루프 발생 가능하다. 

    3. do-while문
    - 조건과 상관없이 최소 1번은 실행된다.

    반복문 제어 키워드
    - continue: 반복문의 현재 반복을 건너뛰고 다음 반복으로 넘어간다.
    - break: 반복문을 즉시 종료한다.
*/

contract Lec12_Loop {

    uint256 limit = 4;

    function sumFor() public view returns (uint256) {
        uint256 sum = 0;

        for (uint256 i = 0; i < limit; i++) {
            sum += i; // sum = sum + 1;
        }
       
        return sum;
    }


    function sumWhile() public view returns (uint256) {
        uint256 sum = 0;
        uint256 i = 0;

        while (i < limit) {
            sum += i; // sum = sum + 1;
            i++;
        }
        return sum;
    }


    function sumDoWhile() public view returns (uint256) {
        uint256 sum = 0;
        uint256 i = 0;

        do {
            sum += i; // sum = sum + 1;
            i++;
        } while (i < limit);

        return sum;
    }


    function logOddIndicesWithContinue(uint256 _limit) public pure {
        for (uint256 i = 0; i < _limit; i++) {

            // 짝수는 건너뜀
            if (i % 2 == 0) {
                continue;
            }

            // 특정 조건에서 반복 종료
            if (i == 5) {
                break;
            }
            console.log("Odd index:", i);
        }
    }

}