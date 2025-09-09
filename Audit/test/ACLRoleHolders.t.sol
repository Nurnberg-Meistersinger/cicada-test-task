// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console2.sol";

import {AddressBook as A} from "../src/AddressBook.sol";
import {IAddressesProviderExt} from "../src/interfaces/IAddressesProviderExt.sol";

// --- ACL core surface present in Solera's ACLManager ---
interface IACLCore {
    // role ids
    function BRIDGE_ROLE() external view returns (bytes32);
    function RISK_ADMIN_ROLE() external view returns (bytes32);
    function ASSET_LISTING_ADMIN_ROLE() external view returns (bytes32);
    // queries
    function hasRole(bytes32 role, address account) external view returns (bool);
    function getRoleAdmin(bytes32 role) external view returns (bytes32);
}

// --- Optional enumerable surface (if implemented) ---
interface IACLEnumerable {
    function getRoleMember(bytes32 role, uint256 index) external view returns (address);
    function getRoleMemberCount(bytes32 role) external view returns (uint256);
}

contract ACLRoleHolders is Test {
    IACLCore              constant ACL = IACLCore(A.ACL_MANAGER);
    IAddressesProviderExt constant AP  = IAddressesProviderExt(A.POOL_ADDRESSES_PROVIDER);

    address[] private CANDIDATES;

    function setUp() public {
        vm.createSelectFork(vm.envString("PLUME_RPC"));

        address owner    = _tryOwner();
        address aclAdmin = _tryACLAdmin();

        // seed candidate set
        CANDIDATES.push(A.PROXY_ADMIN);
        if (owner != address(0)) CANDIDATES.push(owner);
        if (aclAdmin != address(0) && aclAdmin != owner) CANDIDATES.push(aclAdmin);
        CANDIDATES.push(A.TREASURY_PROXY);
        CANDIDATES.push(A.REWARDS_CONTROLLER_PROXY);

        // context
        console2.log("ACL_MANAGER:");
        console2.logAddress(address(ACL));
        console2.log("AP.owner():");
        console2.logAddress(owner);
        console2.log("AP.getACLAdmin():");
        console2.logAddress(aclAdmin);
    }

    function test_List_All_Role_Holders() public view {
        _listRole("BRIDGE_ROLE",              ACL.BRIDGE_ROLE());
        _listRole("RISK_ADMIN_ROLE",          ACL.RISK_ADMIN_ROLE());
        _listRole("ASSET_LISTING_ADMIN_ROLE", ACL.ASSET_LISTING_ADMIN_ROLE());
    }

    // ---- internals ----

    function _listRole(string memory name, bytes32 role) internal view {
        // try enumerable path first
        try IACLEnumerable(address(ACL)).getRoleMemberCount(role) returns (uint256 n) {
            console2.log("==");
            console2.log(name);
            console2.log("(enumerable) members:");
            console2.logUint(n);
            for (uint256 i = 0; i < n; i++) {
                address a = IACLEnumerable(address(ACL)).getRoleMember(role, i);
                console2.log("  holder:");
                console2.logAddress(a);
            }
            console2.log("  adminRoleId:");
            console2.logBytes32(ACL.getRoleAdmin(role));
            return;
        } catch {
            // fallback below
        }

        // fallback: probe known anchors
        console2.log("==");
        console2.log(name);
        console2.log("(fallback scan)");
        console2.log("  adminRoleId:");
        console2.logBytes32(ACL.getRoleAdmin(role));

        bool any;
        for (uint256 i = 0; i < CANDIDATES.length; i++) {
            address who = CANDIDATES[i];
            if (ACL.hasRole(role, who)) {
                any = true;
                console2.log("  holder:");
                console2.logAddress(who);
            }
        }
        if (!any) {
            console2.log("  (no holders found within the current candidate set)");
        }
    }

    function _tryOwner() internal view returns (address a) {
        (bool ok, bytes memory data) =
            address(AP).staticcall(abi.encodeWithSignature("owner()"));
        if (ok && data.length == 32) a = abi.decode(data, (address));
    }

    function _tryACLAdmin() internal view returns (address a) {
        (bool ok, bytes memory data) =
            address(AP).staticcall(abi.encodeWithSignature("getACLAdmin()"));
        if (ok && data.length == 32) a = abi.decode(data, (address));
    }
}