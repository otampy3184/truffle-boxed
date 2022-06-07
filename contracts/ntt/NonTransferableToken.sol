//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "../../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../../node_modules/@openzeppelin/contracts/utils/Counters.sol";

contract SushiNeko is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenCounter;

    constructor() ERC721("SushiNeko", "NEKO") {}

    function mint() public {
        _tokenCounter.increment();

        uint256 newItemId = _tokenCounter.current();
        _mint(msg.sender, newItemId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal pure override {
        // mintは許可（そのまま処理を通す）
	// transferは禁止（処理を中断させる）
        require(from == address(0));
    }
}