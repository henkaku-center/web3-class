// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "./interfaces/IRegistry.sol";

error OnlyOwner();

/// @title Registry
/// @notice This contract is used to manage the whitelist of addresses that can be used across the Chibarihill program.
/// @author thev
contract Registry is IRegistry {
    uint256 public currentCohort = 1;
    address public owner;
    mapping(uint256 => mapping(address => bool)) public whitelist;

    modifier onlyOwner() {
        if (msg.sender != owner) revert OnlyOwner();
        _;
    }

    event CohortAdded(uint256 indexed cohort, address[] members);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /// @notice The constructor sets the owner of the contract.
    constructor() {
        _setOwner(msg.sender);
    }

    /// @notice This function is used to add a new cohort and add addresses to the whitelist.
    /// @dev adding a new cohort invalidates the previous one
    /// @param members Array of addresses of the members of cohort to add.
    function addCohort(address[] memory members) external {
        require(msg.sender == owner, "Only the owner can add a cohort.");
        uint256 cohort = currentCohort;
        for (uint256 i = 0; i < members.length; i++) {
            whitelist[cohort][members[i]] = true;
        }
        currentCohort++;

        emit CohortAdded(cohort, members);
    }

    /// @notice This function is used to check if an address is whitelisted.
    /// @dev this call assumes that you are interested in the current cohort
    /// @param member Address of the member to check.
    /// @return True if the address is whitelisted, false otherwise.
    function isWhitelisted(address member) external view returns (bool) {
        return _isWhitelisted(member, currentCohort);
    }

    /// @notice This function is used to check if an address is whitelisted for a specific cohort.
    /// @param member Address of the member to check.
    /// @param cohort Cohort to check.
    /// @return True if the address is whitelisted, false otherwise.
    function isWhitelistedForCohort(address member, uint256 cohort) external view returns (bool) {
        return _isWhitelisted(member, cohort);
    }

    function _isWhitelisted(address member, uint256 cohort) internal view returns (bool) {
        return whitelist[cohort][member];
    }

    /// @notice This function is used to transfer ownership of the contract.
    /// @param newOwner Address of the new owner.
    function transferOwnership(address newOwner) external onlyOwner {
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) internal {
        emit OwnershipTransferred(owner, newOwner);

        owner = newOwner;
    }
}
