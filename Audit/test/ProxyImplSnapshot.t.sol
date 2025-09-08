// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {AddressBook as A} from "../src/AddressBook.sol";

contract ProxyImplSnapshot is Test {
    // EIP-1967 slots
    bytes32 constant IMPL_SLOT  = bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);
    bytes32 constant ADMIN_SLOT = bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1);

    function setUp() public {
        vm.createSelectFork(vm.envString("PLUME_RPC"));
    }

    function _readImpl(address proxy) internal view returns (address) {
        return address(uint160(uint256(vm.load(proxy, IMPL_SLOT))));
    }

    function _readAdmin(address proxy) internal view returns (address) {
        return address(uint160(uint256(vm.load(proxy, ADMIN_SLOT))));
    }

    function test_PoolProxyImplAndAdmin() public view {
        address impl = _readImpl(A.POOL_PROXY);
        address adm  = _readAdmin(A.POOL_PROXY);
        console2.log("pool.impl:", impl);
        console2.log("pool.admin:", adm);
    }

    function test_ConfiguratorProxyImplAndAdmin() public view {
        address impl = _readImpl(A.POOL_CONFIGURATOR_PROXY);
        address adm  = _readAdmin(A.POOL_CONFIGURATOR_PROXY);
        console2.log("config.impl:", impl);
        console2.log("config.admin:", adm);
    }

    function test_TreasuryProxyImplAndAdmin() public view {
        address impl = _readImpl(A.TREASURY_PROXY);
        address adm  = _readAdmin(A.TREASURY_PROXY);
        console2.log("treasury.impl:", impl);
        console2.log("treasury.admin:", adm);
    }
}