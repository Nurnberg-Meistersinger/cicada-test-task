// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {AddressBook as A} from "../src/AddressBook.sol";
import {IAaveOracle} from "../src/interfaces/IAaveOracle.sol";

contract OracleSnapshot is Test {
    IAaveOracle oracle = IAaveOracle(A.AAVE_ORACLE);

    function setUp() public {
        vm.createSelectFork(vm.envString("PLUME_RPC"));
    }

    function test_Prices() public view {
        uint256 pWETH = oracle.getAssetPrice(A.WETH);
        uint256 pPETH = oracle.getAssetPrice(A.PETH);

        console2.log("price.WETH:", pWETH);
        console2.log("price.pETH:", pPETH);

        require(pWETH > 0 && pPETH > 0, "oracle returned zero");
    }
}