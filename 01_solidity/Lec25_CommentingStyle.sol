// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/*
    Solidity 주석 작성 가이드
 
    - /// 또는 /** * / 형태를 사용하며, NatSpec 태그와 함께 작성한다.
    - // 또는 /* * / 는 단순 코드 설명용이며, 문서화(NatSpec)에는 포함되지 않는다.
 
   
    - 컨트랙트 / 함수 : /** * /
    - 이벤트 / 변수 : /// 
    - 섹션 구분 : /* ///// * /
 
    NatSpec 태그
    - @title   : 컨트랙트 이름
    - @author : 작성자 이름
    - @notice  : 사용자 관점 설명
    - @dev     : 개발자 관점 설명
    - @param   : 함수 입력값 설명
    - @return  : 반환값 설명
 */

/**
 * @title SimpleStorage
 * @author BCMD2026
 * @notice 단일 숫자 값을 저장하고 조회하는 기본 스마트 컨트랙트
 * @dev NatSpec 주석 스타일을 설명하기 위한 교육용 예제
 */
contract SimpleStorage {

    /*//////////////////////////////////////////////////////////////
                                STATE
    //////////////////////////////////////////////////////////////*/

    /// @notice 컨트랙트에 저장되는 단일 숫자 값
    /// @dev storage에 저장되며, 변경 시 gas 비용 발생
    uint256 public storedData;

    /*//////////////////////////////////////////////////////////////
                                FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice 새로운 숫자를 저장한다
     * @dev 상태 변수(storedData)를 변경하므로 gas가 발생한다
     * @param _newValue 새롭게 저장할 숫자 값
     */
    function setValue(uint256 _newValue) external {
        // 이 주석은 NatSpec 주석이 아니므로 적용 되지 않음 (단순 코드 설명용)
        storedData = _newValue;
    }

    /**
     * @notice 저장된 숫자를 반환한다
     * @dev view 함수로 상태 변경이 없으며, 외부 호출 시 gas가 소모되지 않는다
     * @return value 현재 저장된 숫자 값
     */
    function getValue() external view returns (uint256 value) {
        return storedData;
    }
}