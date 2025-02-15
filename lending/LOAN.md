
# MicroLending Fund


1. **Separated Concerns**:
   - `Loan` struct now represents lending pools created by lenders
   - `LoanApplication` struct handles borrower applications and loan status

2. **Lending Pool Features**:
   - Lenders create pools with actual funds
   - Each pool has an available amount that decreases as loans are approved
   - Pools are type-specific (Fixed Term or Instant)
   - One active pool per type per lender

3. **Application Features**:
   - Borrowers apply to specific pools
   - Applications include requested amount, duration, and purpose
   - Repayment tracking moved to LoanApplication struct
   - Clear connection between applications and lending pools

4. **Improved Validation**:
   - Checks for pool existence and available funds
   - Duration validation based on loan type
   - Amount validation against pool limits

5. **Repayment Calculation**:
   - Detailed breakdown of principal, interest, and penalties
   - Flexible penalty calculation based on days late
   - Prevents excessive penalties

6. **Loan Approval**:
   - Only pool lender can approve
   - Proper fund transfer to borrower
   - Updates pool's available amount
   - Sets appropriate due date based on loan duration

7. **Repayment Handling**:
   - Validates repayment amount
   - Handles excess payments
   - Updates pool balance
   - Transfers funds to lender

8. **Pool Management**:
   - Ability to close pools
   - Returns remaining funds to lender
   - Proper status cleanup

9. **View Functions**:
   - Detailed pool information
   - Detailed application information
   - Helper functions to get all pools by lender
   - Helper functions to get all applications by borrower

**Additional features**

1. Helper functions to get all pools/applications for a specific address
2. Proper handling of excess payments **working on this
3. Detailed event emissions for tracking
4. Assembly optimization for array resizing
5. Comprehensive validation checks throughout


[using the lisk testnet dRPC ]

contract hash lisk: 
```sh
0x0b12e1b1ebd496e808bf20b66ca6cc2293212946
```


```javascript
contractABI = [
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": true,
						"internalType": "uint256",
						"name": "poolId",
						"type": "uint256"
					},
					{
						"indexed": true,
						"internalType": "address",
						"name": "lender",
						"type": "address"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "amount",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "interestRate",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "enum MicroLending.LoanType",
						"name": "loanType",
						"type": "uint8"
					}
				],
				"name": "LendingPoolCreated",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": true,
						"internalType": "uint256",
						"name": "applicationId",
						"type": "uint256"
					},
					{
						"indexed": true,
						"internalType": "uint256",
						"name": "poolId",
						"type": "uint256"
					},
					{
						"indexed": true,
						"internalType": "address",
						"name": "borrower",
						"type": "address"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "requestedAmount",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "enum MicroLending.LoanDuration",
						"name": "duration",
						"type": "uint8"
					}
				],
				"name": "LoanApplicationCreated",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": true,
						"internalType": "uint256",
						"name": "applicationId",
						"type": "uint256"
					},
					{
						"indexed": true,
						"internalType": "uint256",
						"name": "poolId",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "address",
						"name": "borrower",
						"type": "address"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "amount",
						"type": "uint256"
					}
				],
				"name": "LoanApproved",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": true,
						"internalType": "uint256",
						"name": "applicationId",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "principal",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "interest",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "penalty",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "daysLate",
						"type": "uint256"
					}
				],
				"name": "LoanRepaid",
				"type": "event"
			},
			{
				"inputs": [],
				"name": "FIXED_TERM_DURATION_DAYS",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "FIXED_TERM_MAX_LOAN",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "INSTANT_LOAN_DURATION_DAYS",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "INSTANT_MAX_LOAN",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "INTEREST_RATE",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "INTEREST_RATE_INSTANT",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "PENALTY_RATE",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "_poolId",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "_requestedAmount",
						"type": "uint256"
					},
					{
						"internalType": "enum MicroLending.LoanDuration",
						"name": "_duration",
						"type": "uint8"
					},
					{
						"internalType": "string",
						"name": "_purpose",
						"type": "string"
					}
				],
				"name": "applyForLoan",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "_applicationId",
						"type": "uint256"
					}
				],
				"name": "approveLoan",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "_applicationId",
						"type": "uint256"
					}
				],
				"name": "calculateRepaymentAmount",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "totalAmount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "principal",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "interest",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "penalty",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "daysLate",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "_poolId",
						"type": "uint256"
					}
				],
				"name": "closeLendingPool",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "createFixedTermPool",
				"outputs": [],
				"stateMutability": "payable",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "createInstantPool",
				"outputs": [],
				"stateMutability": "payable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "_applicationId",
						"type": "uint256"
					}
				],
				"name": "getApplicationDetails",
				"outputs": [
					{
						"internalType": "address",
						"name": "borrower",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "poolId",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "requestedAmount",
						"type": "uint256"
					},
					{
						"internalType": "enum MicroLending.LoanDuration",
						"name": "duration",
						"type": "uint8"
					},
					{
						"internalType": "bool",
						"name": "approved",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "repaid",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "amountRepaid",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "dueDate",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "purpose",
						"type": "string"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "address",
						"name": "_borrower",
						"type": "address"
					}
				],
				"name": "getBorrowerApplications",
				"outputs": [
					{
						"internalType": "uint256[]",
						"name": "",
						"type": "uint256[]"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "address",
						"name": "_lender",
						"type": "address"
					}
				],
				"name": "getLenderPools",
				"outputs": [
					{
						"internalType": "uint256[]",
						"name": "",
						"type": "uint256[]"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "_poolId",
						"type": "uint256"
					}
				],
				"name": "getPoolDetails",
				"outputs": [
					{
						"internalType": "address",
						"name": "lender",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "availableAmount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "interestRate",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "active",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "startTime",
						"type": "uint256"
					},
					{
						"internalType": "enum MicroLending.LoanType",
						"name": "loanType",
						"type": "uint8"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "address",
						"name": "",
						"type": "address"
					}
				],
				"name": "hasFixedTermPool",
				"outputs": [
					{
						"internalType": "bool",
						"name": "",
						"type": "bool"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "address",
						"name": "",
						"type": "address"
					}
				],
				"name": "hasInstantPool",
				"outputs": [
					{
						"internalType": "bool",
						"name": "",
						"type": "bool"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"name": "lendingPools",
				"outputs": [
					{
						"internalType": "address payable",
						"name": "lender",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "availableAmount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "interestRate",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "active",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "startTime",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "poolId",
						"type": "uint256"
					},
					{
						"internalType": "enum MicroLending.LoanType",
						"name": "loanType",
						"type": "uint8"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"name": "loanApplications",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "applicationId",
						"type": "uint256"
					},
					{
						"internalType": "address payable",
						"name": "borrower",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "poolId",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "requestedAmount",
						"type": "uint256"
					},
					{
						"internalType": "enum MicroLending.LoanDuration",
						"name": "duration",
						"type": "uint8"
					},
					{
						"internalType": "bool",
						"name": "approved",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "repaid",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "amountRepaid",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "dueDate",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "purpose",
						"type": "string"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "nextApplicationId",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "nextPoolId",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "_applicationId",
						"type": "uint256"
					}
				],
				"name": "repayLoan",
				"outputs": [],
				"stateMutability": "payable",
				"type": "function"
			}
		]; 
```
		