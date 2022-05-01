// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// 投票機能を有効にしたコントラクト用のインターフェース
interface IVotes {
    event DelegateChanged(
        address indexed delegator,
        address indexed fromDelegate,
        address indexed toDelegate    
    );

    event DelegateVotesChanged(
        address indexed delegate,
        uint256 previousBalance, 
        uint256 newBalance
    );

    function getPastVotes(
        address account,
        uint256 blockNumber
    ) external view returns(uint256);

    function getPastTotalSupply(uint256 blockNumber) external view returns (uint256);

    // accountが選んだデリゲートを返す
    function delegates(address account) external view returns (address);

    // Delegateeに対して投票をセンダーからデリゲートする
    function delegate(address delegatee) external;

    // 署名を使ってDelegateeに対して投票をデリゲートする
    function delegateBySig(
        address delegatee,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;


}