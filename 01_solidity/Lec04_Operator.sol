// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/*
    1. 산술연산자 
        + : 더하기
        - : 빼기
        * : 곱하기
        / : 나누기
        % : 나머지
        ** : 제곱
    
    2. 비교 연산자 
        == : 같다
        != : 다르다
        > : 크다
        < : 작다
        >= : 크거나 같다
        <= : 작거나 같다

    3. 논리 연산자
        && : AND
        || : OR
        ! : NOT

    4. 할당 연산자
        = : 할당
        +=: 증가
        -=: 빼고 할당
        *=: 곱하고 할당
        /=: 나누고 할당
        %=: 나머지 할당
    
    5. 증감 연산자
        ++ : 증가
        -- : 감소

        i++;  // 후위
        ++i;  // 전위

    6. 비트 연산자
        & : AND
        ^ : XOR
        ~ : NOT
        << : 왼쪽 shift
        >> : 오른쪽 shift
  
    7. 논리 연산자
        && : AND
        || : OR
        ! : NOT
*/


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Lec04_Operator {

    // =========================
    // 1. 산술 연산자
    // =========================
    uint256 public a1 = 5 + 3;   // 8
    uint256 public a2 = 5 - 3;   // 2
    uint256 public a3 = 5 * 3;   // 15
    uint256 public a4 = 6 / 3;   // 2
    uint256 public a5 = 5 % 3;   // 2
    uint256 public a6 = 2 ** 3;  // 8

    // =========================
    // 2. 비교 연산자
    // =========================
    bool public c1 = 5 == 3;  // false
    bool public c2 = 5 != 3;  // true
    bool public c3 = 5 > 3;   // true
    bool public c4 = 5 < 3;   // false
    bool public c5 = 5 >= 5;  // true
    bool public c6 = 3 <= 5;  // true

    // =========================
    // 3. 논리 연산자
    // =========================
    bool public l1 = !false;          // true
    bool public l2 = false || true;  // true
    bool public l3 = false && true;  // false
    bool public l4 = true && true;   // true
    bool public l5 = true || false;  // true
    bool public l6 = !true;          // false

    // =========================
    // 4. 할당 연산자
    // =========================
    function assignment() external pure returns (uint256 a, uint256 b, uint256 c, uint256 d, uint256 e, uint256 f) {
        uint256 x = 10;

        a = x;        // 10
        x += 5;       // x = x + 5 → 15
        b = x;        // 15

        x -= 3;       // x = x - 3 → 12   
        c = x;        // 12

        x *= 2;       // x = x * 2 → 24
        d = x;        // 24

        x /= 4;        // x = x / 4 → 6
        e = x;        // 6

        x %= 4;       // x = x % 4 → 2
        f = x;        // 2
    }

    // =========================
    // 5. 증감 연산자 (설명용)
    // =========================
    // 후위 증가 (i++)
    function postIncrement() external pure returns (uint256 beforeValue, uint256 afterValue) {
        uint256 i = 5;

        beforeValue = i++; // 먼저 반환 → 5
        afterValue = i;    // 증가 후 → 6
    }

    // 전위 증가 (++i)
    function preIncrement() external pure returns (uint256 beforeValue, uint256 afterValue) {
        uint256 i = 5;

        beforeValue = ++i; // 먼저 증가 → 6
        afterValue = i;    // 그대로 → 6
    }

    // 감소도 같이
    function decrement() external pure returns (uint256 beforeValue, uint256 afterValue) {
        uint256 i = 5;

        beforeValue = i--; // 5
        afterValue = i;    // 4
    }

    // =========================
    // 6. 비트 연산자
    // =========================
    uint256 public b1 = 5 & 3;   // 1  (0101 & 0011 = 0001)
    uint256 public b2 = 5 | 3;   // 7  (0101 | 0011 = 0111)
    uint256 public b3 = 5 ^ 3;   // 6  (0101 ^ 0011 = 0110)
    uint256 public b4 = 5 << 1;  // 10 (왼쪽 이동 → 2배)
    uint256 public b5 = 5 >> 1;  // 2  (오른쪽 이동 → 절반)
    int256 public b6 = ~int256(5); // -6

}