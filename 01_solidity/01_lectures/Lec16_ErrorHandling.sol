// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";
/*
    Error Handling(에러 처리)
    - 에러 처리는 잘못된 조건이나 예외 상황에서 트랜잭션을 중단시키고 상태 변경을 되돌리기 위해 사용된다. 
    - Solidity는 require, revert, assert 세 가지 키워드를 제공한다. 

    require 
    - 조건을 검사해 false일 경우 트랜잭션을 중단하고 상태 변경을 되돌린다. 
    - 주로 입력값 검증, 조건 체크에 사용된다.
    - 에러 메시지를 함께 작성할 수 있다. 
    - 남은 gas를 소모하지 않고 반환한다.
    
    require(조건, 메시지)
    require(x > 5, "x must be greather than 5");

    revert 
    - 특정 조건에서 명시적으로 트랜잭션을 중단시키고 상태 변경을 되돌린다. 
    - 조건이 없기에 주로 if와 같이 사용된다. 
    - custom Error와 같이 사용될 수 있다. 
    - 남은 gas를 소모하지 않고 반환한다. 

    revert(메시지)
    if(x < 5) {
        revert("x must be greather than 5");
    }

    assert

    - 내부 로직에서 절대 발생하면 안 되는 오류를 검사할 때 사용된다.
    - 주로 invariant(불변 조건) 확인에 사용된다.

    [Solidity 0.8.0 이전]
    - 실패 시 INVALID opcode를 발생시킨다.
    - 남은 gas를 거의 반환하지 않고 대부분 소모된다.
    - 디버깅이 어렵고 비효율적이다.

    [Solidity 0.8.0 이후]
    - 실패 시 Panic(uint) 에러를 발생시키며 revert된다.
    - require/revert와 마찬가지로 남은 gas를 반환한다.
    - 에러 코드(Panic code)로 원인을 구분할 수 있다.

    - assert는 사용자 입력 검증이 아니라, 코드 내부의 버그를 검출하기 위한 용도로 사용해야 한다.

    assert(조건)

    uniswap v2 코드
    uint balance0 = IERC20(token0).balanceOf(address(this));
    uint balance1 = IERC20(token1).balanceOf(address(this));
    // 이 값은 절대 uint112 범위를 넘으면 안 됨
    assert(balance0 <= type(uint112).max && balance1 <= type(uint112).max);

    패닉코드
    - 0x01: assert 실패 오류
    - 0x11: 오버플로우(overflow) / 언더플로우 (underflow)
    - 0x12: 0으로 나눈 오류 (Division by zero)
    - 0x21: enum 범위 오류
    - 0x31: storage byte array 인코딩 오류
    - 0x32: 배열 인덱스 초과 (out-of-bounds)
    - 0x41: 메모리 할당 초과 (memory overflow)
    - 0x51: 초기화되지 않은 내부 함수 호출 (uninitialized function pointer)


    try / catch

    - 외부 컨트랙트 호출 또는 this를 통한 외부 호출에서 발생하는 에러를 처리하기 위한 구문이다.
    - try 블록에서 함수 호출이 성공하면 반환값을 받아 이후 로직을 실행한다.
    - catch 블록은 호출이 실패(revert)했을 때 실행된다.
    - 이를 통해 트랜잭션 전체가 revert 되는 것을 방지하고 예외 처리를 할 수 있다.
    - 버전 0.6 이후로 try / catch 도입이 됐다. 
    - 내부 함수 호출에는 사용이 불가하며, 반드시 외부 호출/ 외부 호출 형태(this.func())로 사용해야한다. 
    
    3가지 에러 처리 방식:
    catch Error(string memory reason)
    - require, revert("message")에서 발생한 에러를 잡는다.

    catch Panic(uint256 errorCode)
    - assert, overflow/underflow 등에서 발생한 Panic 에러를 잡는다.

    catch (bytes memory lowLevelData)
    - 모든 에러를 포괄적으로 처리 (low-level 데이터)

    try otherContract.someFunction() returns (uint result) {
        // 성공 시 실행
    } catch Error(string memory reason) {
        // 일반 revert 메시지 처리
    } catch Panic(uint256 errorCode) {
        // assert 등 Panic 에러 처리
    } catch (bytes memory data) {
        // 기타 모든 에러 처리
    }

*/

contract Lec16_ErrorHandling {
    // custom error
    error MustBeZero();

    function checkWithRequire(uint256 _x) public pure returns (uint256) {
        require(_x > 5, "x must be greater than 5"); // _x가 5 이하이면 오류발생
        return _x;
    }

    function checkWithRevert(uint256 _x) public pure returns (uint256) {
        // _x가 5 이하이면 오류발생
        if(_x <= 5) {
            revert("x must be greater than 5");
        }  
           
        return _x;
    }

    function checkWithCustomError(uint256 _x) public pure returns (uint256) {
        // _x가 0 아니면 오류발생 
        if (_x != 0) revert MustBeZero();
        return _x;
    }

    function checkWithAssert(uint256 _x) public pure returns (uint256) {
         // _x가 0 이면 오류발생
        assert(_x != 0); 
        return _x;
    }

    function tryCatchHandler(uint256 _x) public view returns (uint256, bool) {

        // try/catch는 외부 호출 또는 this.func() 형태의 외부 호출에서만 사용 가능
        try this.checkWithAssert(_x) returns (uint256 result) {
            return(result, true);
        } catch Error(string memory reason) {
            console.log("Error: ", reason);
            return (0, false);
        } catch Panic(uint256 errorCode) {
            console.log("Panic error code: ",errorCode);
            return (0, false);
        } catch (bytes memory data) {
            console.logBytes(data);
            return (0, false);
        }

    }

}


