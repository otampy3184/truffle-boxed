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

    function delegates (address account) public view virtual override returns(address ){
        return _delegates[account];
    }

    function getVotes(address account) public view virtual override returns(uint256){
        uint256 pos = _checkpoints[account].length;
        return pos == 0 ? 0 : _checkpoints[account][pos - 1].votes;
    }

    function getPastVotes(uint256 blockNumber) public view virtual override returns(uint256) {
        require(blockNumber < block.number, "ERC20Votes: block not yet mined");
        return _checkpointsLoop(_totalSupplyCheckpoints, blockNumber);
    }

    function _checkpointsLoop(Checkpoint[] storage ckpts, uint256 blockNumber) private view returns (uint256) {
        uint256 high = ckpts.length;
        uint256 low = 0;
        while (low < high) {
            uint256 mid = Math.average(low, high);
            if (ckpts[mid].fromBlock > blockNumber) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }

        return high == 0 ? 0 : ckpts[high - 1].votes;
    }

    

}

