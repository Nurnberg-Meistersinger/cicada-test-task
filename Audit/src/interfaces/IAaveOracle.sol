// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

/// @notice Aave-style oracle interface we rely on
interface IAaveOracle {
    function getAssetPrice(address asset) external view returns (uint256);
}