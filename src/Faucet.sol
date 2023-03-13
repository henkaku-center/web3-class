// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "./Ownable.sol";
import "./Whitelistable.sol";
import "openzeppelin-contracts/token/ERC20/IERC20.sol";

error FaucetCooldownNotExpired();

/// @title Faucet
/// @notice This contract is used to manage the faucet.
/// @author thev
contract Faucet is Ownable, Whitelistable {
    IERC20 public token;

    uint256 public constant MAX_AMOUNT = 1000000000000000000000; // 1000 tokens
    uint256 public constant MAX_COOLDOWN = 1 days;

    mapping(address => uint256) public cooldown;

    event TokensClaimed(address indexed member, uint256 amount);

    constructor(IRegistry _registry, IERC20 _token) Ownable() Whitelistable(_registry) {
        token = _token;
    }

    function updateRegistry(IRegistry _registry) public override onlyOwner {
        super.updateRegistry(_registry);
    }

    /// @notice This function is used to claim tokens from the faucet.
    /// @dev the amount of tokens is limited to MAX_AMOUNT and the cooldown is limited to MAX_COOLDOWN
    function claim() external onlyWhitelisted {
        if (cooldown[msg.sender] >= block.timestamp) revert FaucetCooldownNotExpired();

        cooldown[msg.sender] = block.timestamp + MAX_COOLDOWN;
        token.transfer(msg.sender, MAX_AMOUNT);

        emit TokensClaimed(msg.sender, MAX_AMOUNT);
    }
}
