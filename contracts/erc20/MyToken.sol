// SPDX-License-Identifier: Unlicenced

pragma solidity ^0.8.0;

import "./ERC20.sol";
import "../access/Ownable.sol";
import "../security/Pausable.sol";
import "./extensions/ERC20Burnable.sol";

// ERC20を継承した独自トークンを作成
contract MyToken is ERC20, Ownable, Pausable, ERC20Burnalbe{
    // アカウントと残高を紐づけるデータ構造
    mapping(address => uint256) private _balances;
    // 転送許容量と各アカウントを紐づけるデータ構造
    mapping(address => mapping(address => uint256)) private _allowance;

    // トークンの名称
    //string private _name;
    string _name;
    // トークンの単位名称
    //string private _symbol;
    string _symbol;

    // 自前のコンストラクタで名称と単位名称を決定する
    // constructor(string memory name_, string memory symbol_) {
    //     _name = name_;
    //     _symbol = symbol_;
    // }

    // 全供給量
    uint256 private _totalSupply;

    // 自前でコンストラクタを用意するのでコメントアウト
    // constructor() ERC20(
    //     "hehe", "sorry"
    // ) {}

    constructor(string memory name_, string memory symbol_, uint8 _decimal){
        _name = name_;
        _symbol = symbol_;
    }

    // 指定した数のトークンを指定のアドレスに対してミントする
    // function mintToken(address recipient, uint256 initialSupply ) public onlyOwner {
    //     _totalSupply = initialSupply;

    //     _mint(recipient, initialSupply);
    // }

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
     * @param address
     * @param uint256
     */
    function _mint(address to, uint256 amount) internal override {
        super._mint(to, amount);
    }
     
    // function mintToken(address recipient, uint256 initialSupply) public {
    //     _totalSupply += initialSupply;
    //     _mint(recipient, initialSupply);
    // }

    /**
     * トークンをburnする
     * @param address
     * @param uint256
     */
    function burn (address to, uint256 amount) public {
        _burn(to, amount);
    }

    /**
     * トークンの全流通量を取得する
     * @return uint256
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * Token移転の前処理
     * @param address
     * @param address 
     * @param uin256
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal whenNotPaused override {
        super._beforeTokenTransfer(from, to, amount);
    }

    /**
     * @param address
     * @param address
     * @param uin256
     */
    function _afterTokenTransfer(address from, address to, uint256 amount) internal whenNotPaused override {
        super._afterTokenTransfer(from, to, amount);
    }

    function get() public view returns (uint256) {
        return _totalSupply;
    }

}
