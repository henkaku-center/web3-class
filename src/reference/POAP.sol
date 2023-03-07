// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "openzeppelin-contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/token/ERC721/IERC721.sol";

import "./interfaces/ITicket.sol";

contract POAP is ERC721 {
    ITicket public immutable ticket;
    uint256 public nextTokenId = 0;

    constructor(ITicket _ticket, string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        ticket = _ticket;
    }

    /// @notice This function is used to mint a new POAP burning the ticket.
    /// @param to Address that will receive the POAP.
    /// @param ticketId Id of the ticket to burn.
    function mint(address to, uint256 ticketId) public {
        uint256 tokenId = nextTokenId;
        ++nextTokenId;

        ticket.burn(ticketId);
        _safeMint(to, tokenId);
    }
}
