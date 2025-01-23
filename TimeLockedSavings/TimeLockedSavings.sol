// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeLockedSavings {

    // Struct to store user deposits and lock details
    struct Deposit {
        uint256 amount;        // Amount deposited
        uint256 lockUntil;     // Timestamp until which the funds are locked
    }

    mapping(address => Deposit) public deposits;  // Mapping of user address to their deposit details
    address public owner;                         // Contract owner

    event Deposited(address indexed user, uint256 amount, uint256 lockUntil);
    event Withdrawn(address indexed user, uint256 amount);
    event OwnerWithdrawn(uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier hasLock(address user) {
        require(deposits[user].lockUntil > 0, "No deposit found for this user");
        _;
    }

    modifier canWithdraw(address user) {
        require(block.timestamp >= deposits[user].lockUntil, "Funds are still locked");
        _;
    }

    constructor() {
        owner = msg.sender;  // Set the contract owner to the deployer's address
    }

    // Function to deposit funds into the savings contract with a lock period
    function deposit(uint256 lockDurationInSeconds) external payable {
        require(msg.value > 0, "You must deposit some funds");
        require(lockDurationInSeconds > 0, "Lock duration must be greater than 0");

        Deposit storage userDeposit = deposits[msg.sender];

        // If the user has an existing deposit, we should not allow new deposits until withdrawal
        require(userDeposit.amount == 0, "You already have an active deposit");

        // Calculate the time until which the funds are locked
        uint256 lockUntil = block.timestamp + lockDurationInSeconds;

        // Save the deposit information
        userDeposit.amount = msg.value;
        userDeposit.lockUntil = lockUntil;

        emit Deposited(msg.sender, msg.value, lockUntil);
    }

    // Function to withdraw funds after the lock period expires
    function withdraw() external hasLock(msg.sender) canWithdraw(msg.sender) {
        Deposit storage userDeposit = deposits[msg.sender];
        uint256 amount = userDeposit.amount;

        require(amount > 0, "No funds to withdraw");

        // Reset the user's deposit details after withdrawal
        userDeposit.amount = 0;
        userDeposit.lockUntil = 0;

        // Transfer funds back to the user
        payable(msg.sender).transfer(amount);

        emit Withdrawn(msg.sender, amount);
    }

    // Owner function to withdraw unclaimed funds from the contract (after some time)
    function ownerWithdraw(uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance in contract");

        // Transfer the amount to the owner's address
        payable(owner).transfer(amount);

        emit OwnerWithdrawn(amount);
    }

    // Function to view the user's deposit status
    function getDepositDetails() external view returns (uint256 amount, uint256 lockUntil) {
        Deposit memory userDeposit = deposits[msg.sender];
        return (userDeposit.amount, userDeposit.lockUntil);
    }

    // Function to check the contract balance (for transparency)
    function getContractBalance() external view onlyOwner returns (uint256) {
        return address(this).balance;
    }

}
