# MicroLending Smart Contract

A decentralized peer-to-peer lending platform built on Ethereum blockchain that enables direct lending between lenders and borrowers without traditional financial intermediaries.

## Overview

The MicroLending smart contract facilitates peer-to-peer lending with the following key features:
- Lender and borrower registration
- Loan application management
- Automated loan approval process
- Interest calculation and repayment tracking
- Penalty management for late payments
- Balance management for all parties

## Contract Structure

### Core Components

1. **Participants**
   - Lenders: Can provide loans and earn interest
   - Borrowers: Can request and receive loans

2. **Key Structures**
   - `Loan`: Contains all loan-related information
   - `LoanApplication`: Manages loan application details
   - `Lender`: Stores lender information
   - `Borrower`: Stores borrower information

### Main Features

#### For Lenders
- Register as a lender
- Deposit funds
- Review loan applications
- Approve loans
- Track loan repayments
- Withdraw funds

#### For Borrowers
- Register as a borrower
- Create loan applications
- Request loans
- Make repayments
- Track loan status and balance

## Function Documentation

### Registration Functions

```solidity
function createLender(string memory _name) external
```
Registers a new lender in the system.
- Parameters:
  - `_name`: The name of the lender

```solidity
function createBorrower(string memory _name) external
```
Registers a new borrower in the system.
- Parameters:
  - `_name`: The name of the borrower

### Loan Application Functions

```solidity
function createApplication(
    uint duration,
    uint interestRate,
    uint creditAmount,
    string memory otherData
) external
```
Creates a new loan application.
- Parameters:
  - `duration`: Loan duration in time units
  - `interestRate`: Annual interest rate
  - `creditAmount`: Amount requested
  - `otherData`: Additional application information

```solidity
function requestLoan(uint _amount) external
```
Requests a new loan.
- Parameters:
  - `_amount`: Amount of loan requested

### Loan Management Functions

```solidity
function approveLoan(address borrower, uint loanIndex) external payable
```
Approves and funds a loan request.
- Parameters:
  - `borrower`: Address of the borrower
  - `loanIndex`: Index of the loan to approve

```solidity
function repayLoanWithInterest(
    uint amount,
    uint estimatedInterest,
    uint timeSinceLastPayment,
    uint loanIndex
) external payable
```
Makes a loan repayment with interest calculation.
- Parameters:
  - `amount`: Repayment amount
  - `estimatedInterest`: Calculated interest amount
  - `timeSinceLastPayment`: Time since last payment
  - `loanIndex`: Index of the loan

### Utility Functions

```solidity
function getLoanBalance(uint _loanIndex) external view returns (uint)
```
Gets the current balance of a specific loan.
- Parameters:
  - `_loanIndex`: Index of the loan

```solidity
function getLoanInfo(uint loanIndex) external view returns (...)
```
Retrieves detailed information about a specific loan.
- Parameters:
  - `loanIndex`: Index of the loan

## Events

The contract emits the following events:
- `LoanRequested`: When a new loan is requested
- `Repayment`: When a repayment is made
- `LoanApproved`: When a loan is approved
- `LoanClosed`: When a loan is fully repaid
- `Penalty`: When a penalty is applied
- `ApplicationCreated`: When a new loan application is created

## Security Features

1. Access Control
   - Modifier `OnlyLender`: Restricts functions to registered lenders
   - Modifier `OnlyBorrower`: Restricts functions to registered borrowers

2. Safety Checks
   - Balance verification before transfers
   - Loan status validation
   - Duplicate registration prevention
   - Active loan checks

## Usage Example

1. Lender Registration:
```javascript
// Register as a lender
await microLending.createLender("John Doe");
// Deposit funds
await microLending.registerLender({ value: ethers.utils.parseEther("1.0") });
```

2. Borrower Registration and Loan Request:
```javascript
// Register as a borrower
await microLending.createBorrower("Jane Doe");
// Create loan application
await microLending.createApplication(30, 5, ethers.utils.parseEther("0.5"), "First time loan");
```

3. Loan Approval and Repayment:
```javascript
// Approve loan (by lender)
await microLending.approveLoan(borrowerAddress, loanIndex);
// Make repayment (by borrower)
await microLending.repayLoanWithInterest(amount, interest, timePassed, loanIndex);
```

## Development and Testing

### Prerequisites
- Node.js v14+ and npm
- Hardhat or Truffle
- OpenZeppelin Contracts

### Installation
1. Clone the repository
2. Install dependencies:
```bash
npm install
```

3. Compile the contract:
```bash
npx hardhat compile
```

4. Run tests:
```bash
npx hardhat test
```

## Security Considerations

1. Always verify loan terms before approval
2. Keep private keys secure
3. Monitor loan status regularly
4. Verify transaction details before signing
5. Be aware of gas costs for various operations

## License

This project is licensed under the MIT License - see the LICENSE file for details.