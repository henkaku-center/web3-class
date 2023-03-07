// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "openzeppelin-contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/token/ERC721/ERC721.sol";
import "./interfaces/ITicket.sol";

error NotEnoughTokens();
error TransferFailed();
error InvalidOwner();

contract Ticket is ERC721, ITicket {
    uint256 public immutable mintPrice;
    IERC20 public immutable token;
    uint256 public nextTokenId = 0;

    constructor(IERC20 _token, uint256 _mintPrice, string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        token = _token;
        mintPrice = _mintPrice;
    }

    /// @notice This function is used to mint a new ticket.
    /// @param to Address of the new owner.
    /// @dev The caller must have enough tokens to pay for the ticket.
    function mint(address to) public {
        if (token.balanceOf(msg.sender) < mintPrice) {
            revert NotEnoughTokens();
        }
        if (!token.transferFrom(msg.sender, address(this), mintPrice)) {
            revert TransferFailed();
        }

        uint256 tokenId = nextTokenId;
        ++nextTokenId;

        _safeMint(to, tokenId);
    }

    /// @notice This function is used to burn a ticket.
    /// @param tokenId Id of the ticket to burn.
    /// @dev The caller must be the owner or approved address of the ticket.
    function burn(uint256 tokenId) public {
        if (!_isApprovedOrOwner(msg.sender, tokenId)) {
            revert InvalidOwner();
        }

        _burn(tokenId);
    }
}
