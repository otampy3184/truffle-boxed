// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./draft-ERC20Permit.sol";
import "../../utils/math/Math.sol";
import "../../governance/IVotes.sol";
import "../../utils/math/SafeCast.sol";
import "../../utils/cryptography/ECDSA.sol";

abstract contract ERC20Votes is IVotes, ERC20Permit {
    struct Checkpoint{
        uint32 fromBlock;
        uint224 votes;
    }

    bytes32 private constant _DELEGATION_TYPEHASH =
        keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");

    mapping(address => address) private _delegates;
    mapping(address => Checkpoint[]) private _checkpoints;
    Checkpoint[] private _totalSupplyCheckpoints;

    // アカウントに紐づいたpos番のcheckpoint値を返す
    function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoint memory) {
        return _checkpoints[account][pos];
    }

    //
    function numCheckpoints(address account) public view virtual returns(uint32){
        return SafeCast.toUint32(_checkpoints[account].length);
    }
}

