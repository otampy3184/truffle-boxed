// SPDX-License-Identifier: Unlicenced

pragma solidity ^0.8.0;

import "./erc20/ERC20.sol";
import "./access/Ownable.sol";

// ERC20を継承した独自トークンを作成
contract MyToken is ERC20, Ownable{
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
    constructor() ERC20(
        "hehe", "sorry"
    ) {}

    // 指定した数のトークンを指定のアドレスに対してミントする
    // function mintToken(address recipient, uint256 initialSupply ) public onlyOwner {
    //     _totalSupply = initialSupply;

    //     _mint(recipient, initialSupply);
    // }

    function pause() public {
        _pause();
    }

    function mintToken(address recipient, uint256 initialSupply) public {
        _totalSupply += initialSupply;
        _mint(recipient, initialSupply);
    }

    // 全供給量を取得する
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    // 
    function get() public view returns (uint256) {
        return _totalSupply;
    }

}
