
# sisi-kwa-sisi


### Frontend Using HTML, CSS, and JavaScript

For the frontend, we'll set up basic interactions where users can contribute, check progress, and request refunds. This will use Web3.js to interact with the Ethereum blockchain.


### Frontend Details:
- **Web3.js:** The code uses Web3.js to interact with the Ethereum blockchain.
- **Campaign Interaction:** Users can contribute funds or request a refund depending on the campaign's status.
- **Contract Functions:** The page interacts with functions like `contribute()` and `refund()`.
- **Styling:** Simple CSS layout for user interaction, with basic inputs for contributions.

### Conclusion:
This code demonstrates a more scalable crowdfunding contract along with a user interface where contributors can participate. The improvements enhance the user experience while making the contract more flexible and efficient. 

###
future Expansion of the code by 
 additional features like campaign cancellation, progress tracking, and notifications.


 sepolia testnet contract
 contract adress 0x662edd5c3bc6e74fbb2e3f3053736cb117b460ff
abi 
```javascript
"abi": [
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "_goal",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "_durationInDays",
						"type": "uint256"
					}
				],
				"stateMutability": "nonpayable",
				"type": "constructor"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": false,
						"internalType": "bool",
						"name": "isActive",
						"type": "bool"
					}
				],
				"name": "CampaignStatusChanged",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": false,
						"internalType": "address",
						"name": "contributor",
						"type": "address"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "amount",
						"type": "uint256"
					}
				],
				"name": "FundReceived",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": false,
						"internalType": "address",
						"name": "owner",
						"type": "address"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "amount",
						"type": "uint256"
					}
				],
				"name": "FundsWithdrawn",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "totalFunds",
						"type": "uint256"
					}
				],
				"name": "GoalReached",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": false,
						"internalType": "address",
						"name": "contributor",
						"type": "address"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "amount",
						"type": "uint256"
					}
				],
				"name": "RefundIssued",
				"type": "event"
			},
			{
				"inputs": [],
				"name": "campaignActive",
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
				"name": "contribute",
				"outputs": [],
				"stateMutability": "payable",
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
				"name": "contributions",
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
				"name": "deadline",
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
				"name": "endCampaign",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "getCampaignStatus",
				"outputs": [
					{
						"internalType": "bool",
						"name": "isActive",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "currentFunds",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "goal",
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
				"name": "goalReached",
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
				"name": "refund",
				"outputs": [],
				"stateMutability": "nonpayable",
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
				"inputs": [],
				"name": "withdrawFunds",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			}
		
```