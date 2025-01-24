// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    mapping(address => uint256) public balances;

    // Deposit Ether into the bank
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    // Withdraw Ether from the bank
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    // Check the balance of the sender
    function balance() external view returns (uint256) {
        return balances[msg.sender];
    }
}
