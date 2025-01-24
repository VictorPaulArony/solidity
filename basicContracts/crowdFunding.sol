// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    address public creator;
    uint256 public goal;
    uint256 public totalFunds;
    uint256 public deadline;
    
    mapping(address => uint256) public contributions;

    event Funded(address indexed donor, uint256 amount);
    event Withdrawal(address indexed creator, uint256 amount);

    modifier onlyCreator() {
        require(msg.sender == creator, "Only the creator can withdraw");
        _;
    }

    modifier isOpen() {
        require(block.timestamp < deadline, "Campaign has ended");
        _;
    }

    modifier hasGoal() {
        require(totalFunds >= goal, "Goal not reached yet");
        _;
    }

    constructor(uint256 _goal, uint256 _duration) {
        creator = msg.sender;
        goal = _goal;
        deadline = block.timestamp + _duration;
    }

    // Contribute funds to the campaign
    function contribute() external payable isOpen {
        require(msg.value > 0, "Must contribute more than 0");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;
        emit Funded(msg.sender, msg.value);
    }

    // Withdraw funds if the goal is met
    function withdraw() external onlyCreator hasGoal {
        payable(creator).transfer(totalFunds);
        emit Withdrawal(creator, totalFunds);
    }

    // Refund all contributions if the goal isn't met
    function refund() external {
        require(block.timestamp >= deadline, "Campaign still ongoing");
        require(totalFunds < goal, "Goal reached, no refunds");

        uint256 amount = contributions[msg.sender];
        require(amount > 0, "No funds to refund");

        contributions[msg.sender] = 0;
        totalFunds -= amount;
        payable(msg.sender).transfer(amount);
    }
}
