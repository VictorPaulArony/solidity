// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CommunityCharityFund {

    address public admin;  // Admin address for managing fund operations
    uint256 public totalDonations;  // Total funds raised in the charity pool

    struct Project {
        uint256 id;                   // Project ID
        string name;                  // Name of the project
        string description;           // Description of the project
        uint256 targetAmount;         // Target funding for the project
        uint256 raisedAmount;         // Amount raised so far for the project
        uint256 votesFor;             // Total votes in favor
        uint256 votesAgainst;         // Total votes against
        address payable beneficiary;  // Address that will receive the funds if the project is approved
        bool isApproved;              // Status of the project approval
        uint256 deadline;             // Deadline for collecting funds and voting
    }

    // Mapping to store projects by their ID
    mapping(uint256 => Project) public projects;
    // Mapping to track the donations
    mapping(address => uint256) public donations;
    // Mapping to track whether an address has voted on a specific project
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    uint256 public projectCounter;  // Counter to generate unique project IDs
    uint256 public donationCounter; // Counter to track donations

    event Donated(address indexed donor, uint256 amount);
    event ProjectProposed(uint256 indexed projectId, string name, uint256 targetAmount, address beneficiary);
    event ProjectApproved(uint256 indexed projectId, address beneficiary, uint256 amount);
    event ProjectFunded(uint256 indexed projectId, address beneficiary, uint256 amount);
    event Voted(uint256 indexed projectId, address voter, bool vote);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyBeforeDeadline(uint256 projectId) {
        require(block.timestamp < projects[projectId].deadline, "Project funding deadline has passed");
        _;
    }

    modifier onlyAfterDeadline(uint256 projectId) {
        require(block.timestamp >= projects[projectId].deadline, "Project funding deadline hasn't passed yet");
        _;
    }

    modifier onlyIfApproved(uint256 projectId) {
        require(projects[projectId].isApproved, "Project not approved");
        _;
    }

    constructor() {
        admin = msg.sender;  // Set the admin as the contract deployer
    }

    // Function to donate to the community charity fund
    function donate() external payable {
        require(msg.value > 0, "Donation must be greater than zero");

        donations[msg.sender] += msg.value;
        totalDonations += msg.value;

        emit Donated(msg.sender, msg.value);
    }

    // Function to propose a new project
    function proposeProject(string memory _name, string memory _description, uint256 _targetAmount, uint256 _deadline, address payable _beneficiary) external {
        require(_targetAmount > 0, "Target amount must be greater than zero");
        require(_deadline > block.timestamp, "Deadline must be in the future");
        require(_beneficiary != address(0), "Invalid beneficiary address");

        uint256 projectId = projectCounter++;

        projects[projectId] = Project({
            id: projectId,
            name: _name,
            description: _description,
            targetAmount: _targetAmount,
            raisedAmount: 0,
            votesFor: 0,
            votesAgainst: 0,
            beneficiary: _beneficiary,
            isApproved: false,
            deadline: _deadline
        });

        emit ProjectProposed(projectId, _name, _targetAmount, _beneficiary);
    }

    // Function to vote on a project (Yes or No)
    function voteOnProject(uint256 projectId, bool _approve) external onlyBeforeDeadline(projectId) {
        require(!hasVoted[projectId][msg.sender], "You have already voted on this project");

        hasVoted[projectId][msg.sender] = true;

        if (_approve) {
            projects[projectId].votesFor += donations[msg.sender]; // Voting weight is based on donation amount
        } else {
            projects[projectId].votesAgainst += donations[msg.sender];
        }

        emit Voted(projectId, msg.sender, _approve);
    }

    // Function to approve a project after voting and funding phase
    function approveProject(uint256 projectId) external onlyAfterDeadline(projectId) {
        require(!projects[projectId].isApproved, "Project already approved");

        Project storage project = projects[projectId];

        // Check if the project has met its target funding and majority votes in favor
        if (project.raisedAmount >= project.targetAmount && project.votesFor > project.votesAgainst) {
            project.isApproved = true;
            emit ProjectApproved(projectId, project.beneficiary, project.raisedAmount);
        }
    }

    // Function to fund the project after approval
    function fundProject(uint256 projectId) external onlyIfApproved(projectId) {
        Project storage project = projects[projectId];

        require(project.raisedAmount < project.targetAmount, "Project is already fully funded");
        require(project.raisedAmount + donations[msg.sender] <= project.targetAmount, "Not enough funds remaining to fund the project");

        project.raisedAmount += donations[msg.sender];
        donations[msg.sender] = 0;  // Reset donor's contribution after funding

        if (project.raisedAmount >= project.targetAmount) {
            // Transfer the total funds to the beneficiary once the project is fully funded
            project.beneficiary.transfer(project.raisedAmount);
            emit ProjectFunded(projectId, project.beneficiary, project.raisedAmount);
        }
    }

    // Admin can withdraw unallocated funds from the charity fund
    function adminWithdraw(uint256 amount) external onlyAdmin {
        require(amount <= address(this).balance, "Insufficient balance");
        payable(admin).transfer(amount);
    }

    // Function to view project details
    function getProjectDetails(uint256 projectId) external view returns (Project memory) {
        return projects[projectId];
    }

    // Function to check the donation amount of a donor
    function getDonationAmount(address donor) external view returns (uint256) {
        return donations[donor];
    }

    // Function to get the total donations raised
    function getTotalDonations() external view returns (uint256) {
        return totalDonations;
    }

}
