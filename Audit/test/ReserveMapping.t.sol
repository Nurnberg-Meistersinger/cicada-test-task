// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {AddressBook as A} from "../src/AddressBook.sol";
import {IProtocolDataProvider, IAToken} from "../src/interfaces/IProtocolDataProvider.sol";

contract ReserveMapping is Test {
    IProtocolDataProvider dp = IProtocolDataProvider(A.PROTOCOL_DATA_PROVIDER);

    function setUp() public {
        vm.createSelectFork(vm.envString("PLUME_RPC"));
    }

    function _check(address underlying, address sExpected, address vExpected) internal view {
        (address aTok,, address vTok) = dp.getReserveTokensAddresses(underlying);
        console2.log("underlying:", underlying);
        console2.log("sToken:", aTok);
        console2.log("vToken:", vTok);
        assertEq(aTok, sExpected, "sToken mismatch");
        assertEq(vTok, vExpected, "vToken mismatch");
        // backref
        assertEq(IAToken(aTok).UNDERLYING_ASSET_ADDRESS(), underlying, "sToken backref mismatch");
    }

    function test_WETH() public view { _check(A.WETH, A.WETH_sTOKEN, A.WETH_vTOKEN); }
    function test_pETH() public view { _check(A.PETH, A.PETH_sTOKEN, A.PETH_vTOKEN); }
}