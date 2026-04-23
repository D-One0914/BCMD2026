// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    외부 컨트랙트 호출 방법 (External Contract Calls)

    - 외부 컨트랙트의 함수를 다양한 방식으로 호출할 수 있다.


    1. new 키워드
    - 새로운 컨트랙트를 생성(배포)한 후 직접 함수를 호출한다.
    - 외부 컨트랙트 호출이라기 보단, 새로운 컨트랙트를 만들어서 사용하는 방식이다.
    - 기존의 컨트랙트와 독립된 인스턴스를 생성하기 때문에, 상태가 공유되지 않는다.
    - 배포 비용이 든다.

    2. Interface 호출
    - 이미 배포된 컨트랙트를 인터페이스를 통해 호출한다.
    - 함수의 형태(규격)를 맞춰 안전하게 호출할 수 있다.
    - 실무에서 가장 많이 사용되는 방식이다.

    3. call (low-level call)
    - 주소를 통해 직접 함수 시그니처를 만들어 호출한다.
    - 타입 체크가 없고, 잘못된 호출도 가능하기 때문에 주의가 필요하다.

    4. staticcall
    - 상태 변경 없이 호출하는 read-only 방식이다.
    - view / pure 함수 호출에 사용된다.
    - 상태를 변경하려 하면 실패한다.

    5. delegatecall
    - 다른 컨트랙트의 코드를 실행하지만, 현재 컨트랙트의 상태(storage)를 사용한다.
    - storage 충돌 등 보안 위험이 있어 매우 주의해야 한다.
    - 주로 Proxy 패턴에서 사용된다.


    핵심 차이
    - new            → 컨트랙트를 생성해서 사용
    - interface      → 이미 존재하는 컨트랙트를 안전하게 호출
    - call           → low-level 방식으로 직접 호출
    - staticcall     → 읽기 전용 호출 (상태 변경 불가)
    - delegatecall   → 외부 코드를 내 상태에서 실행
    
 */

contract Safe {

    event Deposit(address indexed addr, uint256 amount);

    uint256 public balance;

    function deposit(uint256 _amount) external {
        balance += _amount;
        emit Deposit(msg.sender, _amount);
    }

}

contract Lec22_CallWithNew {

    Safe public safe;

    constructor() {
        safe = new Safe();
    }

    function deposit(uint256 _amount) external {
        safe.deposit(_amount);
    }

    function balance() external view returns(uint256) {
        return safe.balance();
    }

} 


interface ISafe {
    function balance() external view returns(uint256);
    function deposit(uint256 _amount) external;
}

contract Lec22_CallWithInterface {

    ISafe immutable safe;

    constructor(address _safe) {
        safe = ISafe(_safe);
    }

    function deposit(uint256 _amount) external {
        safe.deposit(_amount);
    }

    function balance() external view returns(uint256) {
        return safe.balance();
    }

} 

contract Lec22_CallWithCall {

    address public safe;

    constructor(address _safe) {
        safe = _safe;
    }

    function deposit(uint256 _amount) external {
        (bool success, ) = safe.call(
            abi.encodeWithSignature("deposit(uint256)", _amount)
        );
        require(success, "call failed");
    }

    function balance() external view returns (uint256 result) {
        (bool success, bytes memory data) = safe.staticcall(
            abi.encodeWithSignature("balance()")
        );
        require(success, "staticcall failed");
        result = abi.decode(data, (uint256)); // 반환된 bytes 값을 uint256으로 변환
    }
 
}

contract Lec22_CallWithDelegateCall {

    // Safe와 동일한 storage 구조 유지 필요
    uint256 public balance;

    address public safe;

    constructor(address _safe) {
        safe = _safe;
    }

    //  현재 컨트랙트의 balance 변경됨
    function deposit(uint256 _amount) external {
        (bool success, ) = safe.delegatecall(
            abi.encodeWithSignature("deposit(uint256)", _amount)
        );
        require(success, "delegatecall failed");
    }

    function getSafeBalance() external view returns (uint256) {
        return Safe(safe).balance();
    }

}