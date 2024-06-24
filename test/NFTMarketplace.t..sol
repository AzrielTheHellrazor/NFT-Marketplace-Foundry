// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/NFTMarketplace.sol";

contract NFTMarketplaceTest is Test {
    NFTMarketplace marketplace;
    address owner = address(1);
    address buyer = address(2);

    function setUp() public {
        vm.prank(owner);
        marketplace = new NFTMarketplace();
    }

    function testMint() public {
        vm.prank(owner);
        marketplace.mint();
        assertEq(marketplace.balanceOf(owner), 1);
    }

    function testListAndBuyToken() public {
        vm.prank(owner);
        marketplace.mint();

        vm.prank(owner);
        marketplace.listToken(0, 1 ether);

        vm.deal(buyer, 1 ether);
        vm.prank(buyer);
        marketplace.buyToken{value: 1 ether}(0);

        assertEq(marketplace.balanceOf(buyer), 1);
        assertEq(marketplace.balanceOf(owner), 0);
    }

    function testLockAndUnlockToken() public {
        vm.prank(owner);
        marketplace.mint();

        vm.prank(owner);
        marketplace.lockToken(0);

        vm.expectRevert("Token is locked");
        vm.prank(owner);
        marketplace.listToken(0, 1 ether);

        vm.prank(owner);
        marketplace.unlockToken(0);
        
        vm.prank(owner);
        marketplace.listToken(0, 1 ether);
        assertEq(marketplace.tokenPrices(0), 1 ether);
    }
}
