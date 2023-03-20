// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "./interfaces/IRegistry.sol";

abstract contract Whitelistable {
    IRegistry public registry;

    event RegistryUpdated(IRegistry indexed registry);

    constructor(IRegistry _registry) {
        _setRegistry(_registry);
    }

    modifier onlyWhitelisted() {
        _checkWhitelisted(msg.sender);
        _;
    }

    modifier ifWhitelisted(address account) {
        _checkWhitelisted(account);
        _;
    }

    modifier checkWhitelist(address[] memory accounts) {
        require(_checkWhitelisted(accounts), "Whitelistable: Not all accounts are whitelisted");
        _;
    }

    function updateRegistry(IRegistry _registry) public virtual {
        _setRegistry(_registry);
    }

    function _setRegistry(IRegistry _registry) internal {
        registry = _registry;
        emit RegistryUpdated(_registry);
    }

    function _checkWhitelisted(address account) internal view {
        if (!registry.isWhitelisted(account)) revert MemberNotWhitelisted(msg.sender);
    }

    function _checkWhitelisted(address[] memory accounts) internal view returns (bool) {
        return registry.areWhitelisted(accounts);
    }
}
