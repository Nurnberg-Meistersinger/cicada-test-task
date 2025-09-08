// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice Minimal AToken surface to validate back-reference to underlying
interface IAToken {
    function UNDERLYING_ASSET_ADDRESS() external view returns (address);
    function totalSupply() external view returns (uint256);
}

interface IProtocolDataProvider {
    struct TokenAddresses {
        address aTokenAddress;
        address stableDebtTokenAddress;
        address variableDebtTokenAddress;
    }

    function getReserveTokensAddresses(address asset)
        external
        view
        returns (
            address aTokenAddress,
            address stableDebtTokenAddress,
            address variableDebtTokenAddress
        );


    function getReserveData(address asset)
        external
        view
        returns (
            uint256 availableLiquidity,
            uint256 totalStableDebt,
            uint256 totalVariableDebt,
            uint256 liquidityRate,
            uint256 variableBorrowRate,
            uint256 stableBorrowRate,
            uint256 averageStableBorrowRate,
            uint256 liquidityIndex,
            uint256 variableBorrowIndex,
            uint40 lastUpdateTimestamp
        );
}