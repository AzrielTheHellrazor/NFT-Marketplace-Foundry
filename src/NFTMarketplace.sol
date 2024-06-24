// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMarketplace is ERC721, Ownable {
    uint256 public nextTokenId;
    mapping(uint256 => uint256) public tokenPrices;
    mapping(uint256 => bool) public lockedTokens;

    constructor() ERC721("NFTMarketplace", "NFTM") {}

    function mint() external onlyOwner {
        uint256 tokenId = nextTokenId;
        nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

    function listToken(uint256 tokenId, uint256 price) external {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        require(!lockedTokens[tokenId], "Token is locked");
        tokenPrices[tokenId] = price;
    }

    function buyToken(uint256 tokenId) external payable {
        uint256 price = tokenPrices[tokenId];
        require(price > 0, "Token not for sale");
        require(msg.value == price, "Incorrect price");

        address seller = ownerOf(tokenId);
        _transfer(seller, msg.sender, tokenId);

        payable(seller).transfer(msg.value);
        tokenPrices[tokenId] = 0;
    }

    function lockToken(uint256 tokenId) external onlyOwner {
        lockedTokens[tokenId] = true;
    }

    function unlockToken(uint256 tokenId) external onlyOwner {
        lockedTokens[tokenId] = false;
    }
}
