// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//contract for a simple banking system
contract SimpleBank{

    //variable of type adress to store owner addres
    address  public owner;
    //type mapping that store the owner acount balance
    mapping(address => uint) public balance;

    //adding an event for deposit and withdrawals
    //events are used to log changes to the state of the contract(tracking withdraw and deposit)
    event Deposit(address indexed from, uint amount);
    event Withdrawal(address indexed from, uint amount);
    event Transfer(address indexed from, address indexed to, uint amount);

    //special function that executes and set owner variable to address of the user who deloyed the contract
    constructor(){
        owner = msg.sender;
    }

    //function modifier that only allow owner to modify
    modifier onlyOwner(){
        require(
            msg.sender == owner,
            "Only the owner can make modifications"
        );
        _;
    }

    //function to manage the deposit
    function deposit()public payable {
    require(
        msg.sender ==owner,
        "Only the owner of the account can deposit funds"
    );
    require(
        msg.value > 0 ,
        "The amount to be deposited should not be less than 0: "
    );
    balance += msg.value;
    emit Deposit(msg.sender, msg.value);
    }

    //function to allow withdrawal of funds 
    function withdrawal(uint amount) public {
        require(
            msg.sender == owner,
            "Only the ower can withdarw funds from their accounts"
        );
        require(
            amount >0 && amount <= balance,
            "The amount is too much or to low to withdarw: "
        );
        balance -= amount;
        owner.transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

}