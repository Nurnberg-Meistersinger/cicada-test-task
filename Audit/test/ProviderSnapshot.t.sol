// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {AddressBook as A} from "../src/AddressBook.sol";
import {IAddressesProviderExt} from "../src/interfaces/IAddressesProviderExt.sol";

contract ProviderSnapshot is Test {
    IAddressesProviderExt ap = IAddressesProviderExt(A.POOL_ADDRESSES_PROVIDER);

    function setUp() public {
        vm.createSelectFork(vm.envString("PLUME_RPC"));
    }

    function test_AnchorsMatchAddressBook() public view {
        // Verify core anchors against our AddressBook
        assertEq(ap.getPool(), A.POOL_PROXY, "Pool proxy mismatch");
        assertEq(ap.getPoolConfigurator(), A.POOL_CONFIGURATOR_PROXY, "Configurator proxy mismatch");
        assertEq(ap.getACLManager(), A.ACL_MANAGER, "ACLManager mismatch");
        assertEq(ap.getPriceOracle(), A.AAVE_ORACLE, "Oracle mismatch");
    }

    function test_AdminAndSentinel() public view {
        // Read admin layout and oracle sentinel
        address owner = ap.owner();
        address aclAdmin = ap.getACLAdmin();
        address sentinel = ap.getPriceOracleSentinel();

        console2.log("owner:", owner);
        console2.log("aclAdmin:", aclAdmin);
        console2.log("sentinel:", sentinel);

        // Evidence-only checks
        require(sentinel == address(0), "Sentinel should be unset (per snapshot)");
        require(owner == aclAdmin, "Owner and ACL admin should match (per snapshot)");
    }
}