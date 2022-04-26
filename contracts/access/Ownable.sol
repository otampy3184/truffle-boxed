// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../utils/Context.sol";

abstract contract Ownable is Context {
    // owner値
    address private _owner;

    // 所有権移動時に発行されるイベント
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(_msgSender());
    }

    // owner変数を返す
    function owner() public view virtual returns (address) {
        return _owner;
    }

    // コントラクト操作可能者をコントラクトをデプロイしたアカウントにしている修飾子
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    // 所有権をアドレスゼロに渡して実質消す
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    // ownershio移転処理
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner ) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}