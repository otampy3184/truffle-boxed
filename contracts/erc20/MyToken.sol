// SPDX-License-Identifier: Unlicenced

pragma solidity ^0.8.0;

import "./ERC20.sol";
import "../access/Ownable.sol";
import "../security/Pausable.sol";
import "./extensions/ERC20Burnable.sol";
import "./extensions/draft-ERC20Permit.sol";

// ERC20を継承した独自トークンを作成
contract MyToken is ERC20, Ownable, Pausable, Ownable, ERC20Burnalbe {
    string tokenName;
    string tokenSymbol;

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        tokenName = _name;
        tokenSymbol = _symbol;
    }

    /**
     * 停止関数
     */
    function pause() public {
        _pause();
    }

    /**
     * 停止解除関数（外部用）
     */
    function unpause_() public {
        unpause();
    }

    /**
     * 停止解除関数
     */
    function unpause() internal override {
        _unpause();
    }

    /**
     * トークンをミントする
     * @param to mint先
     * @param amount mint量
     */
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    /**
     * トークンをburnする
     * @param to burn to 
     * @param amount burn amount
     */
    function burn (address to, uint256 amount) public {
        _burn(to, amount);
    }

    /**
     * Token移転の前処理
     * @param from from address
     * @param to to address 
     * @param amount amount
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal whenNotPaused override {
        super._beforeTokenTransfer(from, to, amount);
    }

    /**
     * @param from from address
     * @param to to address 
     * @param amount amount
     */
    function _afterTokenTransfer(address from, address to, uint256 amount) internal whenNotPaused override {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal override(ERC20) {
        super._mint(to, amount);
    }

    function _burn (address account, uint256 amount) internal override(ERC20) {
        super._burn(account, amount);
    }
}
