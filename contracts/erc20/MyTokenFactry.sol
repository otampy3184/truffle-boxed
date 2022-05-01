// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./MyToken.sol";

// MyTokenを発行するためのコントラクト
contract MyTokenFactory {
    // MyToken型の配列
    MyToken[] private _myTokens;
    uint256 constant maxLimit = 20;

    /**
     * MyTokenが作成された時に出力されるイベント
     */
    event MyTokenCreated (MyToken indexed myToken, address indexed owner);

    /**
     * インスタンス数を取得するmyTokensCount関数
     * public view
     * @return uint256 
     */
    function myTokensCount() public view returns (uint256) {
        return _myTokens.length;
    }

    /**
     * MyTokenコントラクト生成関数createMyToken関数
     * public
     * @param name string memory Token名
     * @param symbol string memory シンボル名
     * @param decimal uint8 小数点
     */
    function cretateMyToken(string memory name, string memory symbol, uint8 decimal) public {
        //MyToken myToken = new MyToken(name, symbol, decimal);
        MyToken myToken = new MyToken();

        myToken.transferOwnership(msg.sender);
        _myTokens.push(myToken);
        emit MyTokenCreated(myToken, msg.sender);
    }

    /**
     * MyTokenコントラクト群を取得するmyTokens関数
     * public view
     * @param limit uint256 上限取得値
     * @param offset uint256 取得数
     * @return coll MyTokenコントラクトの配列
     */
     function myTokens (uint256 limit, uint256 offset) public virtual returns (MyToken[] memory coll) {
         // 事前確認
         require(offset <= myTokensCount(), "offset out of bounds");
         // 最大値を上回っている場合はLimitを格納する
         uint256 size = myTokensCount() - offset;
         size = size < Limit ? size : limit;
         // sizeはmaxLimitを超えてはならない
         size = size < maxLimit ? size : maxLimit;
         // コントラクト用の配列
         coll = new MyToken[](size);
         
         for (uint256 i = 0; i < size; i++){
             coll[i] = _myTokens[offset + i];
         }

         return coll;
     }


}