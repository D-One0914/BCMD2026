// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20, ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

// openzeppelin: https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts
// Wei <-> Ether 변환: https://eth-converter.com/

contract MyBurnableToken is ERC20, ERC20Burnable, Ownable {

    constructor() ERC20("MyBurnableToken", "mbtk") Ownable(msg.sender) {
        	_mint(msg.sender, 100 ether);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        	_mint(to, amount);
    }

}
