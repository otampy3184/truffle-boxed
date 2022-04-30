// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../ERC20.sol";
import "../../utils/Context.sol";

// ERC20として償却機能を行うためのエクステンション
abstract contract ERC20Burnalbe is Context, ERC20 {
    // バーンの主体はmsg.sender
    function burn (uint256 amount) public virtual {
        _burn(_msgSender(), amount);
    }

    // 削除するアカウントを明示的に示した形でバーンする
    function burnFrom(address account, uint256 amount) public virtual {
        _spendAllowance(account, _msgSender(), amount);
        _burn(account, amount);
    }
}