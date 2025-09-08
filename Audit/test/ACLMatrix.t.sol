// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console2.sol";

import {AddressBook as A} from "../src/AddressBook.sol";
import {IAddressesProviderExt} from "../src/interfaces/IAddressesProviderExt.sol";

interface IACLManager {
    // role ids
    function POOL_ADMIN_ROLE() external view returns (bytes32);
    function EMERGENCY_ADMIN_ROLE() external view returns (bytes32);
    function RISK_ADMIN_ROLE() external view returns (bytes32);
    function ASSET_LISTING_ADMIN_ROLE() external view returns (bytes32);
    function BRIDGE_ROLE() external view returns (bytes32);
    // queries
    function hasRole(bytes32 role, address account) external view returns (bool);
    function isPoolAdmin(address account) external view returns (bool);
    function isEmergencyAdmin(address account) external view returns (bool);
    function isRiskAdmin(address account) external view returns (bool);
    function isAssetListingAdmin(address account) external view returns (bool);
    function isBridge(address account) external view returns (bool);
    // meta
    function getRoleAdmin(bytes32 role) external view returns (bytes32);
}

contract ACLMatrix is Test {
    IACLManager constant ACL = IACLManager(A.ACL_MANAGER);
    IAddressesProviderExt constant AP = IAddressesProviderExt(A.POOL_ADDRESSES_PROVIDER);

    address[] addrs;
    string[] labels;

    function setUp() public {
        vm.createSelectFork(vm.envString("PLUME_RPC"));

        address aclAdmin = AP.getACLAdmin();
        address owner    = AP.owner();

        // init arrays with fixed length we need
        addrs  = new address[](5);
        labels = new string[](5);

        addrs[0] = A.PROXY_ADMIN;              labels[0] = "PROXY_ADMIN";
        addrs[1] = aclAdmin;                   labels[1] = "ACL_ADMIN(AP)";
        addrs[2] = owner;                      labels[2] = "OWNER(AP)";
        addrs[3] = A.POOL_ADDRESSES_PROVIDER;  labels[3] = "ADDRESSES_PROVIDER";
        addrs[4] = A.TREASURY_PROXY;           labels[4] = "TREASURY_PROXY";

        console2.log("ACL_MANAGER:", address(ACL));
        console2.log("AP.owner():", owner);
        console2.log("AP.getACLAdmin():", aclAdmin);
    }

    function test_ACL_Matrix() public view {
        _scanRole("POOL_ADMIN",          ACL.POOL_ADMIN_ROLE());
        _scanRole("EMERGENCY_ADMIN",     ACL.EMERGENCY_ADMIN_ROLE());
        _scanRole("RISK_ADMIN",          ACL.RISK_ADMIN_ROLE());
        _scanRole("ASSET_LISTING_ADMIN", ACL.ASSET_LISTING_ADMIN_ROLE());
        _scanRole("BRIDGE",              ACL.BRIDGE_ROLE());
    }

    // --- helpers ---
    function _scanRole(string memory roleName, bytes32 roleId) internal view {
        console2.log("== Role:", roleName);
        console2.logBytes32(roleId);

        for (uint256 i = 0; i < addrs.length; i++) {
            if (ACL.hasRole(roleId, addrs[i])) {
                console2.log("  holder ->", labels[i]);
                console2.logAddress(addrs[i]); // отдельный лог для адреса
            }
        }
    }
}