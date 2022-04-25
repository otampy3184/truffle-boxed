// SPDX-License-Identifier: Unlicenced

pragma solidity ^0.8.0;

import "./erc20/ERC20.sol";

// ERC20を継承した独自トークンを作成
contract MyToken is ERC20{
    uint256 private _totalSupply;

    constructor() ERC20(
        "hehe", "sorry"
    ) {}

    function mintToken(address recipient, uint256 initialSupply ) public {
        _totalSupply = initialSupply;

        _mint(recipient, initialSupply);
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

}
