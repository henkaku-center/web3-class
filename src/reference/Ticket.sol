// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "openzeppelin-contracts/token/ERC20/IERC20.sol";

contract Ticket {
    IERC20 public immutable token;
    uint256 public immutable mintPrice;
    uint256 nextTicketId = 0;
    mapping(uint256 => address) public ownerOf;

    event TicketMinted(uint256 indexed ticketId, address indexed owner);

    constructor(IERC20 _token, uint256 _mintPrice) {
        token = _token;
        mintPrice = _mintPrice;
    }

    function mint(address _to) public {
        token.transferFrom(msg.sender, address(this), mintPrice);
        ownerOf[nextTicketId] = _to;
        ++nextTicketId;

        emit TicketMinted(nextTicketId, _to);
    }

    function burn(uint256 _ticketId) public {
        require(ownerOf[_ticketId] == msg.sender, "Only the owner can burn the ticket");
        delete ownerOf[_ticketId];
    }
}
