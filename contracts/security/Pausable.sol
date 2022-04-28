// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../utils/Context.sol";

contract Pausable is Context {
    event Paused(address account);

    event Unpaused(address account);

    //　停止/不停止の管理は真偽値で管理する
    bool private _paused;

    // デフォルトでは停止ステータスはFalseとする
    constructor() {
        _paused = false;
    }

    modifier whenNotPaused() {
        require(!paused(), "Pausable: paused");
        _;
    }

    modifier whenPaused() {
        require(paused(), "Pausable: not paused");
        _;
    }

    function paused() public view virtual returns (bool) {
        return _paused;
    }

    function unpause() internal virtual {
        unpause();
    }

    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}
