// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    매핑(Mapping) 
    - 키와 값으로 이루어진 자료구조이다.
    - 키는 중복될 수 없으며, 값은 중복될 수 있다.

    매핑 생성법 
    mapping(키의 데이터 타입 => 값의 데이터 타입) 가시성 지정자 변수명;
    mapping(uint256 => uint256) public mapping1;

    매핑의 멤버 함수/속성
    - mapping1[키] = 값; // 키와 값 추가
    - uint256 value = mapping1[키];
    - delete mapping1[키]; // 값 삭제

    구조체(Struct)
    - 서로 다른 타입의 데이터를 하나로 묶는 사용자 정의 타입이다.  
    
    구조체 생성법
    struct 구조체명 {
        데이터 타입 변수명1;
        데이터 타입 변수명2;
        ...
    }

*/


contract Lec14_Mapping {
    // 모든 키는 존재하며, 키에 해당하는 값은 string의 초기값인 ""를 갖는다. 
    mapping(uint256 => string) studentName;
    mapping(uint256 id => string name) studentName2; // 0.8.18+ 이후 버전에서 도입된 키워드 매핑 문법

    // 키에 해당하는 값 수정
    function updateStudentName(uint256 _id, string calldata _name) public {
        studentName[_id] = _name;
    }

    // 키에 해당하는 값 조회
    function  getStudentName (uint256 _id) public view returns (string memory) {
        return studentName[_id];
    }

    // 키에 해당하는 값 삭제 (값이 초기값으로 변경되며, 키는 여전히 존재한다.) 
    function deleteStudentName(uint256 _id) public {
        delete studentName[_id];
    }
}

contract Lec14_Struct {
    
    // 구조체 정의
    struct Student {
        string name;
        uint256 age;
    }

    // 구조체 변수 선언 및 초기화
    Student public studentA = Student("Alice", 25);

    // 4가지 방법으로 구조체 값 수정
    function setStudent(string calldata _name, uint256 _age) public {
        studentA = Student(_name, _age);
    }

    function setStudent2(string calldata _name, uint256 _age) public {
        studentA = Student({
            name: _name,
            age: _age
        });
    }

    function addStudents3(Student calldata _student) public {
        studentA = _student;
    }

    function setStudent4(string calldata _name, uint256 _age) public {
        studentA.name = _name; 
        studentA.age = _age;
    }

    // 2가지 방법으로 구조체 값 조회
    function getStudent() public view returns (string memory, uint256) {
        return (studentA.name, studentA.age);
    }

    function getStudent2() public view returns (Student memory) {
        return studentA;
    }
}

contract Lec14_Map_Struct {

    struct Student {
        string name;
        uint256 age;
    } 

    mapping(uint256 id => Student) public Students;
    

    function addStudents(uint256 _id, string calldata _name, uint256 _age) public {
        Students[_id] = Student({
            name: _name,
            age: _age
        });
    }
  
    function getStudents(uint256 _id) public view returns(string memory, uint256) {
        return (Students[_id].name, Students[_id].age);
    }

}





