// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lotto{
    address public owner;
    address[] public payable ;
    uint public  ticketPrice;
    bool public lottoOpen;

    event TicketPurchased(address indexed player, uint amount);
    event WinnerSelected(address indexed winner uint prize);

    constructor{
        owner = msg.sender;
        ticketPrice = _ticketPrice;
        lottoOpen = true;
    }

    modifier onlyOwner(){
        require(
        msg.sender == owner,
        "Only the owner can modify the contract"
        );
        _;
    }

    modifier isLottoOpen(){
        require(
            lottoopen,
            "The lottery is opened"
        );
        _;
    }

    function buyTicket()public payable lottoOpen{
        require(
            msg.value == ticketPrice,
            "Incorrect ticket price"
        );

        players.Push(msg.sender);
        emit TicketPurchased(msg.sender, msg.value);
    }

    function drawWinner()public onlyOwner{
        require(
            players.length > 0,
            "No player in the lottery"
        );
        randomIndex = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, player)))% players.length;
        address winner = players[randomIndex];

        uint prize = address(this).balance;
        
        (bool success,) = winner.call{value: prize}("");
        require(
            success, 
            "Prize transfer failed"
        );
        emit  WinnerSelected(winner, prize);
        player = new address lottoOpen = false;
    }
    function startNewRound(uint _ticketPrice) public onlyOwner{
        require(
            !lotoOpen,
            "Current lotto is stil active"
        );
        ticketPrice = _ticketPrice;
        lottoOpen = true;

    }
    function getPlayer() public  view returns(address[] memory){
        return  players;
    }



}