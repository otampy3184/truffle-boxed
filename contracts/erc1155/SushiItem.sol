// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../../node_modules/@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "../../node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "../../node_modules/@openzeppelin/contracts/utils/Strings.sol";

// ERC1155を継承したコントラクトSushiItemを作成
contract SushiItem is ERC1155 {
    using Counters for Counters.Couter;
    Counters.Couter private _tokenCounter;

    // ネタの文字列を数字で表現
    uint256 public constant TUNE = 0;
    uint256 public constant SALMON = 1;
    uint256 public constant TOROTAKU = 2;
    uint256 public constant TAMAGO = 3;
    uint256 public constant UIN = 4;

    // メタデータを作成するURI用の変数を設定
    string baseMetadataURIPrefix;
    string baseMetadataURISuffix;

    // コンストラクタを設定
    constructor() ERC1155("") {
        baseMetadataURIPrefix = "https://firebasestorage.googleapis.com/v0/b/solidity-sandbox.appspot.com/o/erc1155example%2Fmetadata%2F";
        baseMetadataURISuffix = ".json?alt=media";

        // 親コントラクトのミントを呼び出してトークンを設定する
        // デフォルトの所有者はコントラクトをデプロイしたEOA
        // _mint()では、"id"typeのトークンを"amount"量だけ"address"に対して送信する
        _mint(msg.sender, TUNA, 100, "");
        _mint(msg.sender, SALMON, 100, "");
        _mint(msg.sender, TOROTAKU, 100, "");
        _mint(msg.sender, TAMAGO, 100, "");
        _mint(msg.sender, UNI, 100, "");
    }

    // uri()では"id"typeのURIを返す
    function uri(uint256 _id) public view override returns (string memory) {
        return string(abi.encodePacked(
            baseMetadataURIPrefix,
            Strings.toString(_id),
            baseMetadataURISuffix
        ));
    }

    // mint()は_mint()の内部実装で、実行者はコントラクト所有者に設定している
    function mint(uint256 _tokenId, uint256 _amount) public {
        _mint(msg.sender, _tokenId, _amount, "");
    }

    // mintBatch()は_mintBatch()の内部実装で、実行者はデフォルトでmsg.senderとしている
    function mintBatch(uint256[] memory _tokenIds, uint256[] memory _amounts) public {
        _mintBatch(msg.sender, _tokenIds, _amounts, "");
    }

    // setBaseMetadatataURIでURI情報などの書き換えを可能にする
    function setBaseMetadataURI(string memory _prefix, string memory _suffix) public {
        baseMetadataURIPrefix = _prefix;
        baseMetadataURISuffix = _suffix;
    }

    

}