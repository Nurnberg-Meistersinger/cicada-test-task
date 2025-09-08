// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice AddressesProvider getters used in our snapshots
interface IAddressesProviderExt {
    function getPool() external view returns (address);
    function getPoolConfigurator() external view returns (address);
    function getACLManager() external view returns (address);

    function owner() external view returns (address);
    function getACLAdmin() external view returns (address);

    function getPriceOracle() external view returns (address);
    function getPriceOracleSentinel() external view returns (address);

    function getMarketId() external view returns (string memory);
    function getAddress(bytes32 id) external view returns (address);
}