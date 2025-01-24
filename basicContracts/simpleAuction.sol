// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleAuction {
    address public owner;
    uint256 public highestBid;
    address public highestBidder;
    uint256 public auctionEndTime;

    mapping(address => uint256) public bids;

    event BidPlaced(address indexed bidder, uint256 amount);
    event AuctionEnded(address indexed winner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can end the auction");
        _;
    }

    modifier auctionEnded() {
        require(block.timestamp >= auctionEndTime, "Auction has not ended");
        _;
    }

    constructor(uint256 _duration) {
        owner = msg.sender;
        auctionEndTime = block.timestamp + _duration;
    }

    // Place a bid
    function placeBid() external payable {
        require(msg.value > highestBid, "Bid is too low");

        // Refund the previous highest bidder
        if (highestBid != 0) {
            payable(highestBidder).transfer(highestBid);
        }

        highestBid = msg.value;
        highestBidder = msg.sender;
        emit BidPlaced(msg.sender, msg.value);
    }

    // End the auction and transfer the highest bid to the owner
    function endAuction() external onlyOwner auctionEnded {
        payable(owner).transfer(highestBid);
        emit AuctionEnded(highestBidder, highestBid);
    }
}
