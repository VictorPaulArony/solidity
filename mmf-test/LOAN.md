
    "function createFund(string memory _name, address _investmentAccount, uint256 _dividendPeriodInDays) external payable returns (string memory)",
    "function joinMMF(string memory _niceId) external payable",
    "function distributeDividends(string memory _niceId) external payable",
    "function claimDividends(string memory _niceId) external",
    "function getAllActiveFunds() external view returns (string[] memory, string[] memory, uint256[] memory, uint256[] memory)",
    "function trackActivity() external payable"





lisk testnet
contract address = "0x8a750bf8fb94264364abac1000e09a2ee0d40a65"
contract "abi": [
			{
				"inputs": [],
				"stateMutability": "nonpayable",
				"type": "constructor"
			},
			{
				"inputs": [
					{
						"internalType": "address",
						"name": "owner",
						"type": "address"
					}
				],
				"name": "OwnableInvalidOwner",
				"type": "error"
			},
			{
				"inputs": [
					{
						"internalType": "address",
						"name": "account",
						"type": "address"
					}
				],
				"name": "OwnableUnauthorizedAccount",
				"type": "error"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": true,
						"internalType": "uint256",
						"name": "fundId",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "amount",
						"type": "uint256"
					}
				],
				"name": "DividendDistributed",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": true,
						"internalType": "uint256",
						"name": "fundId",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "string",
						"name": "mmfName",
						"type": "string"
					},
					{
						"indexed": false,
						"internalType": "address",
						"name": "manager",
						"type": "address"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "initialMinInvestment",
						"type": "uint256"
					}
				],
				"name": "FundCreated",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": true,
						"internalType": "uint256",
						"name": "fundId",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "bool",
						"name": "isActive",
						"type": "bool"
					}
				],
				"name": "FundStatusChanged",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": true,
						"internalType": "uint256",
						"name": "fundId",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "address",
						"name": "investor",
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
						"name": "shares",
						"type": "uint256"
					}
				],
				"name": "InvestmentMade",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": true,
						"internalType": "address",
						"name": "previousOwner",
						"type": "address"
					},
					{
						"indexed": true,
						"internalType": "address",
						"name": "newOwner",
						"type": "address"
					}
				],
				"name": "OwnershipTransferred",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": false,
						"internalType": "address",
						"name": "account",
						"type": "address"
					}
				],
				"name": "Paused",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": true,
						"internalType": "uint256",
						"name": "fundId",
						"type": "uint256"
					},
					{
						"indexed": true,
						"internalType": "address",
						"name": "from",
						"type": "address"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "amount",
						"type": "uint256"
					}
				],
				"name": "TopUpReceived",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": false,
						"internalType": "address",
						"name": "account",
						"type": "address"
					}
				],
				"name": "Unpaused",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": true,
						"internalType": "uint256",
						"name": "fundId",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "address",
						"name": "investor",
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
						"name": "shares",
						"type": "uint256"
					}
				],
				"name": "WithdrawalMade",
				"type": "event"
			},
			{
				"inputs": [],
				"name": "INITIAL_FUNDING",
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
				"name": "INITIAL_SHARE_PRICE",
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
				"name": "MANAGEMENT_FEE_PERCENTAGE",
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
				"name": "MAX_INVESTORS",
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
				"name": "MIN_INVESTMENT",
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
						"name": "_fundId",
						"type": "uint256"
					}
				],
				"name": "chargeManagementFee",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "_fundId",
						"type": "uint256"
					}
				],
				"name": "claimDividend",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "string",
						"name": "_mmfName",
						"type": "string"
					},
					{
						"internalType": "address",
						"name": "_investmentAccount",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "_dividendPeriod",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "_initialMinInvestment",
						"type": "uint256"
					}
				],
				"name": "createFund",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "_fundId",
						"type": "uint256"
					}
				],
				"name": "distributeDividends",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "emergencyPause",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "emergencyUnpause",
				"outputs": [],
				"stateMutability": "nonpayable",
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
				"name": "funds",
				"outputs": [
					{
						"internalType": "address",
						"name": "mmfManager",
						"type": "address"
					},
					{
						"internalType": "address",
						"name": "investmentAccount",
						"type": "address"
					},
					{
						"internalType": "string",
						"name": "mmfName",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "totalAssets",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "currentInvestors",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "creationTime",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "dividendPeriod",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "lastDividendTime",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isActive",
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
						"name": "_fundId",
						"type": "uint256"
					}
				],
				"name": "getAllInvestors",
				"outputs": [
					{
						"internalType": "address[]",
						"name": "",
						"type": "address[]"
					},
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
						"name": "_fundId",
						"type": "uint256"
					}
				],
				"name": "getInvestorFundDetails",
				"outputs": [
					{
						"internalType": "string",
						"name": "mmfName",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "totalAssets",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "currentInvestors",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "investedAmount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "shares",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "lastDepositTime",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "lastDividendClaimed",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "getOpenFunds",
				"outputs": [
					{
						"internalType": "uint256[]",
						"name": "openFunds",
						"type": "uint256[]"
					},
					{
						"internalType": "string[]",
						"name": "mmfNames",
						"type": "string[]"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "_fundId",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "_initialInvestment",
						"type": "uint256"
					}
				],
				"name": "invest",
				"outputs": [],
				"stateMutability": "payable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "_fundId",
						"type": "uint256"
					}
				],
				"name": "managerTopUp",
				"outputs": [],
				"stateMutability": "payable",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "owner",
				"outputs": [
					{
						"internalType": "address",
						"name": "",
						"type": "address"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "paused",
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
				"inputs": [],
				"name": "renounceOwnership",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "_fundId",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "_status",
						"type": "bool"
					}
				],
				"name": "setFundStatus",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "_fundId",
						"type": "uint256"
					}
				],
				"name": "topUpInvestment",
				"outputs": [],
				"stateMutability": "payable",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "totalFunds",
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
						"internalType": "address",
						"name": "newOwner",
						"type": "address"
					}
				],
				"name": "transferOwnership",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "_fundId",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "_amount",
						"type": "uint256"
					}
				],
				"name": "withdraw",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			}
		]