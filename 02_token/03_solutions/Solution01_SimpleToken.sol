// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/*

SimpleToken

1. 필요 한 것들
  - 토큰 이름
  - 토큰 심볼
  - 토큰 총 갯수
  - 유저 토큰 잔액
  - 토큰 생성 (mint)
  - 토큰 생성 (전송)


※ 본 컨트랙트는 ERC20 전체 표준이 아닌, 학습용으로 단순화된 토큰입니다.
※ mint 함수는 실제 환경에서는 onlyOwner 등의 접근제어가 필요하나, 설명 단순화를 위해 생략했습니다.
※ Wei <-> Ether 변환: https://eth-converter.com/
*/

contract SimpleToken {

    string public name;
    string public symbol;
    uint256 public totalSupply;
    mapping(address user => uint256 balance) public balanceOf;

    error InsufficentBalance();

    event Transfer(address indexed from, address indexed to, uint256 amount);

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        mint(msg.sender, 100_000 ether);
    }

    function mint(address _receiver, uint256 _amount) public {
        balanceOf[_receiver] += _amount; // balanceOf[_receiver] = balanceOf[_receiver] + _amount;
        totalSupply += _amount; // totalSupply = totalSupply + _amount;
        emit Transfer(address(0), _receiver, _amount);
    }

    function transfer(address _receiver, uint256 _amount) external {
        uint256 balance = balanceOf[msg.sender];
        
        if (balance < _amount) {
            revert InsufficentBalance();
        }

        unchecked {
            balanceOf[msg.sender] = balance - _amount;
        }

        balanceOf[_receiver] += _amount;
        emit Transfer(msg.sender, _receiver, _amount);
    }
}
