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
        _checkWhitelisted();
        _;
    }

    function updateRegistry(IRegistry _registry) public virtual {
        _setRegistry(_registry);
    }

    function _setRegistry(IRegistry _registry) internal {
        registry = _registry;
        emit RegistryUpdated(_registry);
    }

    function _checkWhitelisted() internal view {
        if (!registry.isWhitelisted(msg.sender)) revert MemberNotWhitelisted(msg.sender);
    }
}
