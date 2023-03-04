// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/token/ERC20/extensions/ERC20Votes.sol";
import "openzeppelin-contracts/token/ERC20/extensions/ERC20Wrapper.sol";

contract ChitWrappedVotes is ERC20, ERC20Votes, ERC20Wrapper {
    constructor(IERC20 _token)
        ERC20("Governance Chiba IT University Token", "wvCHIT")
        ERC20Permit("Governance Chiba IT University Token")
        ERC20Wrapper(_token)
    {}

    function decimals() public view virtual override(ERC20, ERC20Wrapper) returns (uint8) {
        return super.decimals();
    }

    function _afterTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._burn(account, amount);
    }
}
