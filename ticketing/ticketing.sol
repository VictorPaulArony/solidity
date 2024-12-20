// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Contract to award tickets to buyers
contract Ticketing {

    // Struct for the ticket 
    struct Ticket {
        address owner;
        address buyer;
        uint amount;
        bool isIssued;
    }

    // Declaration of the state variables of the contract
    uint public ticketIdCounter;
    mapping(uint => Ticket) public tickets;

    // Events for logging functions
    event TicketCreated(uint ticketId, uint amount);
    event TicketIssued(uint ticketId, address buyer);
    event TicketBought(uint ticketId, address buyer, uint amount);

    // Function to create the event ticket
    function createTicket(uint _amount) external {
        require(
            _amount > 0,
            "The amount entered must be greater than 0."
        );

        // Updating the state of the function
        ticketIdCounter++;
        tickets[ticketIdCounter] = Ticket({
            owner: msg.sender,
            buyer: address(0),
            amount: _amount,
            isIssued: false
        });

        // Event logging by emitting
        emit TicketCreated(ticketIdCounter, _amount);
    }

    // Function for the owner to issue tickets to the buyers
    function issueTicket(uint ticketId) external payable {
        Ticket storage ticket = tickets[ticketId];
        require(
            ticket.amount > 0,
            "The ticket has no amount set."
        );
        require(
            !ticket.isIssued,
            "The ticket is already issued."
        );
        require(
            msg.value == ticket.amount,
            "The sent amount does not match the ticket price."
        );

        // Updating the state of the ticket
        ticket.buyer = msg.sender;
        ticket.isIssued = true;

        // Event logging
        emit TicketIssued(ticketId, msg.sender);
    }

    // Function to let the buyer buy a ticket
    function buyTicket(uint ticketId) external payable {
        Ticket storage ticket = tickets[ticketId];
        
        require(
            ticket.buyer == address(0), 
            "The ticket has already been sold or issued."
        );
        require(
            !ticket.isIssued,
            "The ticket is already issued to someone else."
        );
        require(
            msg.value == ticket.amount,
            "The sent amount does not match the ticket price."
        );

        // Updating the ticket state
        ticket.buyer = msg.sender;
        ticket.isIssued = true;

        // Transfer the payment to the owner
        payable(ticket.owner).transfer(msg.value);

        // Logging the purchase
        emit TicketBought(ticketId, msg.sender, msg.value);
    }

    // Function to view the details of a ticket
    function getTicketDetails(uint ticketId) public view returns(address owner, address buyer, uint amount, bool isIssued) {
        Ticket storage ticket = tickets[ticketId];
        return (
            ticket.owner,
            ticket.buyer,
            ticket.amount,
            ticket.isIssued
        );
    }
}
