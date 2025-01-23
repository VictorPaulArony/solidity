// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FreelancerEscrow {
    
    address public admin;  // Admin address (can be a DAO or owner of the contract)
    uint256 public escrowFee;  // Admin fee for escrow service (if needed)

    enum State { Pending, Active, Completed, Disputed, Refunded }
    enum DisputeResolution { None, Employer, Freelancer }

    struct Escrow {
        address employer;           // Employer who hired the freelancer
        address freelancer;         // Freelancer hired for the job
        uint256 amount;             // Amount of the job
        uint256 depositTime;        // Timestamp when the funds were deposited
        State state;                // Current state of the escrow
        DisputeResolution dispute;  // Who the arbiter decided in case of a dispute
        address arbiter;            // Arbitrator address for resolving disputes
    }

    mapping(uint256 => Escrow) public escrows;  // Mapping from escrow ID to the Escrow struct
    uint256 public escrowCounter;                // Counter to create unique escrow IDs

    event EscrowCreated(uint256 indexed escrowId, address employer, address freelancer, uint256 amount);
    event PaymentReleased(uint256 indexed escrowId, address recipient, uint256 amount);
    event EscrowCancelled(uint256 indexed escrowId, address employer);
    event DisputeRaised(uint256 indexed escrowId, address by);
    event DisputeResolved(uint256 indexed escrowId, DisputeResolution winner, address arbiter);

    modifier onlyEmployer(uint256 _escrowId) {
        require(msg.sender == escrows[_escrowId].employer, "Only the employer can perform this action");
        _;
    }

    modifier onlyFreelancer(uint256 _escrowId) {
        require(msg.sender == escrows[_escrowId].freelancer, "Only the freelancer can perform this action");
        _;
    }

    modifier onlyArbiter(uint256 _escrowId) {
        require(msg.sender == escrows[_escrowId].arbiter, "Only the arbiter can perform this action");
        _;
    }

    modifier inState(uint256 _escrowId, State _state) {
        require(escrows[_escrowId].state == _state, "Invalid state for this action");
        _;
    }

    modifier onlyActive(uint256 _escrowId) {
        require(escrows[_escrowId].state == State.Active, "Escrow is not active");
        _;
    }

    modifier onlyPending(uint256 _escrowId) {
        require(escrows[_escrowId].state == State.Pending, "Escrow is not in pending state");
        _;
    }

    modifier onlyRefundable(uint256 _escrowId) {
        require(
            escrows[_escrowId].state == State.Pending || 
            escrows[_escrowId].state == State.Disputed, 
            "Escrow is not refundable"
        );
        _;
    }

    modifier onlyCompleted(uint256 _escrowId) {
        require(escrows[_escrowId].state == State.Completed, "Work is not completed yet");
        _;
    }

    constructor(uint256 _escrowFee) {
        admin = msg.sender;
        escrowFee = _escrowFee; // Escrow fee (optional, can be used for platform fees)
        escrowCounter = 0;
    }

    // Create a new escrow for a freelancer job
    function createEscrow(address _freelancer) external payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        require(_freelancer != address(0), "Invalid freelancer address");
        
        uint256 escrowId = escrowCounter++;
        
        escrows[escrowId] = Escrow({
            employer: msg.sender,
            freelancer: _freelancer,
            amount: msg.value,
            depositTime: block.timestamp,
            state: State.Pending,
            dispute: DisputeResolution.None,
            arbiter: address(0)
        });
        
        emit EscrowCreated(escrowId, msg.sender, _freelancer, msg.value);
    }

    // Employer confirms completion of work and releases payment
    function confirmWorkAndRelease(uint256 _escrowId) external onlyEmployer(_escrowId) onlyActive(_escrowId) {
        escrows[_escrowId].state = State.Completed;

        uint256 amount = escrows[_escrowId].amount;
        address freelancer = escrows[_escrowId].freelancer;

        // Transfer funds to the freelancer (optional fee deduction can be added)
        payable(freelancer).transfer(amount);

        emit PaymentReleased(_escrowId, freelancer, amount);
    }

    // Employer cancels the escrow and requests a refund (if no work has been completed)
    function cancelEscrow(uint256 _escrowId) external onlyEmployer(_escrowId) onlyPending(_escrowId) {
        uint256 amount = escrows[_escrowId].amount;
        
        // Refund the employer
        escrows[_escrowId].state = State.Refunded;
        payable(msg.sender).transfer(amount);

        emit EscrowCancelled(_escrowId, msg.sender);
    }

    // Freelancer claims that the work is completed and the employer should release funds
    function claimCompletion(uint256 _escrowId) external onlyFreelancer(_escrowId) onlyActive(_escrowId) {
        escrows[_escrowId].state = State.Completed;

        uint256 amount = escrows[_escrowId].amount;
        // address employer = escrows[_escrowId].employer;

        // Transfer funds to the freelancer (optional fee deduction can be added)
        payable(msg.sender).transfer(amount);

        emit PaymentReleased(_escrowId, msg.sender, amount);
    }

    // Employer or Freelancer raises a dispute
    function raiseDispute(uint256 _escrowId) external onlyActive(_escrowId) {
        require(
            msg.sender == escrows[_escrowId].employer || msg.sender == escrows[_escrowId].freelancer,
            "Only the employer or freelancer can raise a dispute"
        );

        escrows[_escrowId].state = State.Disputed;
        emit DisputeRaised(_escrowId, msg.sender);
    }

    // Arbiter resolves a dispute and decides the outcome
    function resolveDispute(uint256 _escrowId, DisputeResolution _resolution) external onlyArbiter(_escrowId) {
        require(escrows[_escrowId].state == State.Disputed, "No dispute to resolve");
        
        // Set the resolution outcome
        escrows[_escrowId].state = State.Completed;
        escrows[_escrowId].dispute = _resolution;

        address recipient;
        uint256 amount = escrows[_escrowId].amount;

        if (_resolution == DisputeResolution.Employer) {
            recipient = escrows[_escrowId].employer;
        } else {
            recipient = escrows[_escrowId].freelancer;
        }

        // Transfer the funds based on the resolution
        payable(recipient).transfer(amount);

        emit DisputeResolved(_escrowId, _resolution, msg.sender);
    }

    // Employer or Freelancer refunds the deposit (if no dispute)
    function refundDeposit(uint256 _escrowId) external onlyRefundable(_escrowId) {
        require(msg.sender == escrows[_escrowId].employer || msg.sender == escrows[_escrowId].freelancer, "Only employer or freelancer can request a refund");
        
        uint256 amount = escrows[_escrowId].amount;
        
        // Refund the amount
        escrows[_escrowId].state = State.Refunded;
        payable(msg.sender).transfer(amount);
    }

    // Set an arbiter for a disputed escrow
    function setArbiter(uint256 _escrowId, address _arbiter) external onlyEmployer(_escrowId) {
        require(escrows[_escrowId].state == State.Disputed, "Escrow is not disputed");
        escrows[_escrowId].arbiter = _arbiter;
    }
}
