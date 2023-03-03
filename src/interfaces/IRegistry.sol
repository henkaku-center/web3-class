// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

error MemberNotWhitelisted(address member);

/// @title IRegistry
/// @notice This is the interface for a registry contract
/// @author thev
interface IRegistry {
    function currentCohort() external view returns (uint256);

    function isWhitelisted(address member) external view returns (bool);

    function isWhitelistedForCohort(address member, uint256 cohort) external view returns (bool);
}
