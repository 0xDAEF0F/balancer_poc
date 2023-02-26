// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {IVault} from "@ibalancer/vault/IVault.sol";
import {IAsset} from "@ibalancer/vault/IAsset.sol";
// logging
import {console} from "forge-std/console.sol";

/*//////////////////////////////////////////////////////////////
                          POOL WBTC/USDC/WETH
//////////////////////////////////////////////////////////////*/
// POOLID:  0x64541216bafffeec8ea535bb71fbc927831d0595000100000000000000000002
// ADDRESS: 0x64541216bAFFFEec8ea535BB71Fbc927831d0595
// WETH ADDRESS: 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1
// USDC ADDRESS: 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8

contract SwapBalancer is Test {
    uint256 forkId =
        vm.createSelectFork(vm.envString("ARBITRUM_RPC_URL"), 64271681);
    IVault balancerVault = IVault(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
    address wethWhale = 0xc2707568D31F3fB1Fc55B2F8b2ae5682eAa72041;

    function setUp() public {
        vm.label(wethWhale, "Whale");
    }

    function testSwap() public {
        vm.startPrank(wethWhale);
        balancerVault.WETH().approve(address(balancerVault), 1 ether);
        IVault.SingleSwap memory singleSwap = IVault.SingleSwap({
            kind: IVault.SwapKind.GIVEN_IN,
            poolId: 0x64541216bafffeec8ea535bb71fbc927831d0595000100000000000000000002,
            // WETH
            assetIn: IAsset(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1),
            // USDC
            assetOut: IAsset(0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8),
            amount: 1 ether,
            userData: ""
        });
        IVault.FundManagement memory fundManagement = IVault.FundManagement({
            sender: wethWhale,
            fromInternalBalance: false,
            recipient: payable(wethWhale),
            toInternalBalance: false
        });
        uint amount = balancerVault.swap(
            singleSwap,
            fundManagement,
            0,
            block.timestamp
        );
        console.log("amount:", amount);
    }
}
