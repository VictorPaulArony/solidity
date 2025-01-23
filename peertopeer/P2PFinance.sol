// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract P2PFinance {

    // Structure to store information about each money market
    struct MoneyMarket {
        uint256 id;                     // Unique ID for the money market
        address creator;                // Address of the market creator
        uint256 interestRate;           // Interest rate for loans (in basis points, 100bps = 1%)
        uint256 totalDeposits;          // Total amount deposited in the market
        uint256 totalLoans;             // Total amount of loans requested
        uint256 loanTerm;               // Loan term in seconds (e.g., 30 days)
        bool isActive;                  // Whether the market is active or closed
        mapping(address => uint256) lenders;   // Lender's deposit amounts in the market
        mapping(address => uint256) borrowers; // Borrower's loan amounts
    }

    // Mapping to store all money markets
    mapping(uint256 => MoneyMarket) public moneyMarkets;
    uint256 public marketCount;  // Counter to create unique market IDs

    // Events
    event MarketCreated(uint256 indexed marketId, address creator, uint256 interestRate, uint256 loanTerm);
    event LoanRequested(uint256 indexed marketId, address indexed borrower, uint256 amount);
    event LoanFulfilled(uint256 indexed marketId, address indexed lender, address indexed borrower, uint256 amount);
    event LoanRepaid(uint256 indexed marketId, address indexed borrower, uint256 amount);
    event DepositToMarket(uint256 indexed marketId, address indexed lender, uint256 amount);
    event WithdrawFromMarket(uint256 indexed marketId, address indexed lender, uint256 amount);

    modifier onlyMarketCreator(uint256 marketId) {
        require(msg.sender == moneyMarkets[marketId].creator, "Only market creator can perform this action");
        _;
    }

    modifier marketIsActive(uint256 marketId) {
        require(moneyMarkets[marketId].isActive, "Market is not active");
        _;
    }

    modifier marketExists(uint256 marketId) {
        require(moneyMarkets[marketId].creator != address(0), "Market does not exist");
        _;
    }

    modifier onlyBorrower(uint256 marketId) {
        require(moneyMarkets[marketId].borrowers[msg.sender] > 0, "You are not a borrower in this market");
        _;
    }

    modifier onlyLender(uint256 marketId) {
        require(moneyMarkets[marketId].lenders[msg.sender] > 0, "You are not a lender in this market");
        _;
    }

    // Function to create a new money market
    function createMoneyMarket(uint256 interestRate, uint256 loanTerm) external {
        require(interestRate > 0, "Interest rate must be greater than 0");
        require(loanTerm > 0, "Loan term must be greater than 0");

        uint256 marketId = marketCount++;
        MoneyMarket storage newMarket = moneyMarkets[marketId];
        
        newMarket.id = marketId;
        newMarket.creator = msg.sender;
        newMarket.interestRate = interestRate;
        newMarket.loanTerm = loanTerm;
        newMarket.isActive = true;

        emit MarketCreated(marketId, msg.sender, interestRate, loanTerm);
    }

    // Function to deposit funds into a money market as a lender
    function depositToMarket(uint256 marketId) external payable marketExists(marketId) marketIsActive(marketId) {
        require(msg.value > 0, "Deposit must be greater than 0");

        moneyMarkets[marketId].lenders[msg.sender] += msg.value;
        moneyMarkets[marketId].totalDeposits += msg.value;

        emit DepositToMarket(marketId, msg.sender, msg.value);
    }

    // Function to withdraw funds from a money market as a lender
    function withdrawFromMarket(uint256 marketId, uint256 amount) external onlyLender(marketId) marketExists(marketId) marketIsActive(marketId) {
        require(amount <= moneyMarkets[marketId].lenders[msg.sender], "Insufficient deposit");

        moneyMarkets[marketId].lenders[msg.sender] -= amount;
        moneyMarkets[marketId].totalDeposits -= amount;

        payable(msg.sender).transfer(amount);

        emit WithdrawFromMarket(marketId, msg.sender, amount);
    }

    // Function to request a loan from a money market
    function requestLoan(uint256 marketId, uint256 amount) external marketExists(marketId) marketIsActive(marketId) {
        MoneyMarket storage market = moneyMarkets[marketId];

        require(amount > 0, "Loan amount must be greater than 0");
        require(market.totalDeposits >= amount, "Insufficient funds in the market");

        market.borrowers[msg.sender] = amount;
        market.totalLoans += amount;

        emit LoanRequested(marketId, msg.sender, amount);
    }

    // Function to fulfill a loan request from a borrower
    function fulfillLoan(uint256 marketId, address borrower) external marketExists(marketId) marketIsActive(marketId) {
        MoneyMarket storage market = moneyMarkets[marketId];
        uint256 loanAmount = market.borrowers[borrower];

        require(loanAmount > 0, "No loan requested by borrower");
        require(market.totalDeposits >= loanAmount, "Insufficient funds in the market");

        uint256 lenderAmount = msg.sender.balance;
        require(lenderAmount >= loanAmount, "Insufficient funds to fulfill the loan");

        market.borrowers[borrower] = 0; // Reset the borrower's loan request
        payable(borrower).transfer(loanAmount);

        emit LoanFulfilled(marketId, msg.sender, borrower, loanAmount);
    }

    // Function to repay a loan
    function repayLoan(uint256 marketId) external payable onlyBorrower(marketId) marketExists(marketId) marketIsActive(marketId) {
        MoneyMarket storage market = moneyMarkets[marketId];

        uint256 amountDue = market.borrowers[msg.sender] * (100 + market.interestRate) / 100;
        require(msg.value >= amountDue, "Insufficient repayment amount");

        // Reset the borrower's loan amount
        market.borrowers[msg.sender] = 0;

        // Transfer the repayment to the lenders
        payable(market.creator).transfer(amountDue);

        emit LoanRepaid(marketId, msg.sender, amountDue);
    }

    // Function to close a money market
    function closeMoneyMarket(uint256 marketId) external onlyMarketCreator(marketId) marketExists(marketId) {
        MoneyMarket storage market = moneyMarkets[marketId];

        require(market.totalLoans == 0, "Market still has outstanding loans");
        market.isActive = false;
    }

    // Function to check the details of a money market
    function getMarketDetails(uint256 marketId) external view returns (address creator, uint256 interestRate, uint256 loanTerm, uint256 totalDeposits, uint256 totalLoans, bool isActive) {
        MoneyMarket storage market = moneyMarkets[marketId];
        return (market.creator, market.interestRate, market.loanTerm, market.totalDeposits, market.totalLoans, market.isActive);
    }

    // Function to check the lender's balance in a specific market
    function getLenderBalance(uint256 marketId) external view returns (uint256) {
        return moneyMarkets[marketId].lenders[msg.sender];
    }

    // Function to check the borrower's loan balance in a specific market
    function getBorrowerLoan(uint256 marketId) external view returns (uint256) {
        return moneyMarkets[marketId].borrowers[msg.sender];
    }
}
