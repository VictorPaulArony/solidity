
let contract;
let web3;
let accounts;
const contractAddress = '0x662edd5c3bc6e74fbb2e3f3053736cb117b460ff';
const contractABI = [
    
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
		
];

async function init() {
    if (typeof window.ethereum !== 'undefined') {
        web3 = new Web3(window.ethereum);
        contract = new web3.eth.Contract(contractABI, contractAddress);
        updateUI();
        setupEventListeners();
    } else {
        showError('Please install MetaMask to use this dApp');
    }
}

async function connectWallet() {
    try {
        accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
        document.getElementById('connectWalletBtn').style.display = 'none';
        updateUI();
    } catch (error) {
        showError('Failed to connect wallet: ' + error.message);
    }
}

async function updateUI() {
    if (!accounts || accounts.length === 0) return;

    const [goal, deadline, totalFunds, isOwner, campaignActive] = await Promise.all([
        contract.methods.goal().call(),
        contract.methods.deadline().call(),
        contract.methods.totalFunds().call(),
        contract.methods.owner().call().then(owner => owner.toLowerCase() === accounts[0].toLowerCase()),
        contract.methods.campaignActive().call()
    ]);

    document.getElementById('goalAmount').textContent = web3.utils.fromWei(goal, 'ether') + ' ETH';
    document.getElementById('raisedAmount').textContent = web3.utils.fromWei(totalFunds, 'ether') + ' ETH';
    
    const timeLeft = Math.max(0, deadline - Math.floor(Date.now() / 1000));
    document.getElementById('timeLeft').textContent = Math.floor(timeLeft / 86400) + ' days';
    
    const progress = (totalFunds / goal) * 100;
    document.getElementById('progressBar').style.width = `${Math.min(100, progress)}%`;

    // Show/hide buttons based on user role and campaign status
    document.getElementById('withdrawBtn').style.display = isOwner ? 'block' : 'none';
    document.getElementById('endCampaignBtn').style.display = isOwner ? 'block' : 'none';
    document.getElementById('refundBtn').style.display = !campaignActive ? 'block' : 'none';
}

async function contribute() {
    try {
        const amount = document.getElementById('contributeAmount').value;
        const weiAmount = web3.utils.toWei(amount, 'ether');
        
        await contract.methods.contribute().send({
            from: accounts[0],
            value: weiAmount
        });
        
        showSuccess('Contribution successful!');
        updateUI();
    } catch (error) {
        showError('Contribution failed: ' + error.message);
    }
}

async function withdraw() {
    try {
        await contract.methods.withdrawFunds().send({ from: accounts[0] });
        showSuccess('Funds withdrawn successfully!');
        updateUI();
    } catch (error) {
        showError('Withdrawal failed: ' + error.message);
    }
}

async function requestRefund() {
    try {
        await contract.methods.refund().send({ from: accounts[0] });
        showSuccess('Refund processed successfully!');
        updateUI();
    } catch (error) {
        showError('Refund failed: ' + error.message);
    }
}

async function endCampaign() {
    try {
        await contract.methods.endCampaign().send({ from: accounts[0] });
        showSuccess('Campaign ended successfully!');
        updateUI();
    } catch (error) {
        showError('Failed to end campaign: ' + error.message);
    }
}

function setupEventListeners() {
    document.getElementById('connectWalletBtn').addEventListener('click', connectWallet);
    document.getElementById('contributeBtn').addEventListener('click', contribute);
    document.getElementById('withdrawBtn').addEventListener('click', withdraw);
    document.getElementById('refundBtn').addEventListener('click', requestRefund);
    document.getElementById('endCampaignBtn').addEventListener('click', endCampaign);

    // Contract events
    contract.events.FundReceived()
        .on('data', event => addEventToList('New contribution received'));

    contract.events.GoalReached()
        .on('data', event => addEventToList('Funding goal reached!'));

    contract.events.FundsWithdrawn()
        .on('data', event => addEventToList('Funds withdrawn by owner'));

    contract.events.RefundIssued()
        .on('data', event => addEventToList('Refund issued to contributor'));

    contract.events.CampaignStatusChanged()
        .on('data', event => addEventToList('Campaign status updated'));
}

function addEventToList(message) {
    const eventsList = document.getElementById('eventsList');
    const eventItem = document.createElement('div');
    eventItem.className = 'event-item';
    eventItem.textContent = `${new Date().toLocaleTimeString()} - ${message}`;
    eventsList.insertBefore(eventItem, eventsList.firstChild);
}

function showSuccess(message) {
    const alert = document.getElementById('successAlert');
    alert.textContent = message;
    alert.style.display = 'block';
    setTimeout(() => alert.style.display = 'none', 3000);
}

function showError(message) {
    const alert = document.getElementById('errorAlert');
    alert.textContent = message;
    alert.style.display = 'block';
    setTimeout(() => alert.style.display = 'none', 3000);
}

init();
