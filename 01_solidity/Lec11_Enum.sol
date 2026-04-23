// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";
/*
    enum (열거형)

    - enum은 정수(uint8) 값에 이름을 붙여 사용하는 자료형이다.
    - enum은 uint8 기반이므로, 최대 256개(0~255)의 값에 이름을 정의 할 수 있다.
    - 주로 상태 관리(예: 진행 단계, 승인 여부 등)에 사용된다.
    - uint(status)와같이 enum은 정수형으로 캐스팅이 가능하다.
    - enum은 비교(==)가 가능하다.
*/

contract Lec11_Enum {

    enum Status { Pending, Active, Ended, Unknown }

    Status public currentStatus;

    function setStatus(Status _status) external {
        currentStatus = _status;
    }

    function logStatus() external view {
        if (currentStatus == Status.Pending) console.log("Pending");
        else if (uint256(currentStatus) == 1) console.log("Active");
        else if (Status(2) == Status.Ended) console.log("Ended");
        else console.log("Unknown");
    }

}
