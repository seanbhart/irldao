// SPDX-License-Identifier: MIT
pragma solidity >=0.6.8;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TESTERC721 is ERC721 {
    uint256 public tokenCounter;
    constructor () public ERC721 ("Apester", "APER"){
        tokenCounter = 0;
    }

    function createCollectible() public returns (uint256) {
        uint256 newItemId = tokenCounter;
        _safeMint(msg.sender, newItemId);
        // _setTokenURI(newItemId, tokenURI);
        tokenCounter = tokenCounter + 1;
        return newItemId;
    }

}