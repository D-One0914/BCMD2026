// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

// openzeppelin: https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts
// Wei <-> Ether 변환: https://eth-converter.com/

contract MyToken is ERC20, Ownable {

    constructor() ERC20("MyToken", "mtk") Ownable(msg.sender) {
        _mint(msg.sender, 100 ether);
    }

    function mint(address to, uint256 amount) external  onlyOwner {
        _mint(to, amount);
    }

}