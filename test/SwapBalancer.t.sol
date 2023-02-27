// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {IVault} from "@ibalancer/vault/IVault.sol";
import {IAsset} from "@ibalancer/vault/IAsset.sol";
// logging
import {console} from "forge-std/console.sol";

/*//////////////////////////////////////////////////////////////
                          POOL rETH/WETH
//////////////////////////////////////////////////////////////*/
// POOL ID:  0x1e19cf2d73a72ef1332c882f20534b6519be0276000200000000000000000112
// POOL ADDRESS: 0x1E19CF2D73a72Ef1332C882F20534B6519Be0276
// wETH ADDRESS: 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
// rETH ADDRESS: 0xae78736Cd615f374D3085123A210448E74Fc6393

contract SwapBalancer is Test {
    uint256 forkId =
        vm.createSelectFork(vm.envString("MAINNET_RPC_URL"), 16721325);

    IAsset weth = IAsset(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IAsset reth = IAsset(0xae78736Cd615f374D3085123A210448E74Fc6393);

    IVault balancerVault = IVault(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
    address wethWhale = 0x4b7fEcEffE3b14fFD522e72b711B087f08BD98Ab;

    function setUp() public {
        vm.label(wethWhale, "Whale");
    }

    function testSwap() public {
        vm.startPrank(wethWhale);
        balancerVault.WETH().approve(address(balancerVault), 1 ether);
        IVault.SingleSwap memory singleSwap = IVault.SingleSwap({
            kind: IVault.SwapKind.GIVEN_IN,
            poolId: 0x1e19cf2d73a72ef1332c882f20534b6519be0276000200000000000000000112,
            // wETH
            assetIn: weth,
            // rETH
            assetOut: reth,
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
