// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {AddressBook as A} from "../src/AddressBook.sol";
import {IProtocolDataProvider, IAToken} from "../src/interfaces/IProtocolDataProvider.sol";

interface IPoolMinimal {
    function getReserveNormalizedIncome(address asset) external view returns (uint256);
    function getReserveNormalizedVariableDebt(address asset) external view returns (uint256);
}

contract ReserveSnapshot is Test {
    IProtocolDataProvider dp = IProtocolDataProvider(A.PROTOCOL_DATA_PROVIDER);
    IPoolMinimal pool = IPoolMinimal(A.POOL_PROXY);

    function setUp() public {
        vm.createSelectFork(vm.envString("PLUME_RPC"));
    }

    function _lightSnapshot(address asset) internal view {
        (address aTok,, address vTok) = dp.getReserveTokensAddresses(asset);

        assertTrue(aTok != address(0) && vTok != address(0), "token addrs empty");
        assertEq(IAToken(aTok).UNDERLYING_ASSET_ADDRESS(), asset, "aToken backref");

        uint256 supply = IAToken(aTok).totalSupply();
        uint256 vDebt  = IAToken(vTok).totalSupply();

        uint256 liqIndex = pool.getReserveNormalizedIncome(asset);
        uint256 varIndex = pool.getReserveNormalizedVariableDebt(asset);

        assertGt(liqIndex, 0, "liqIndex==0");
        assertGt(varIndex, 0, "varIndex==0");

        assertLt(liqIndex, 1e32, "liqIndex huge");
        assertLt(varIndex, 1e32, "varIndex huge");

        require(supply + vDebt + liqIndex + varIndex >= 0, "touch");
    }

    function test_Snapshot_WETH() public view { _lightSnapshot(A.WETH); }
    function test_Snapshot_pETH() public view { _lightSnapshot(A.PETH); }
}