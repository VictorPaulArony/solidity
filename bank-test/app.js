const provider = new ethers.providers.Web3Provider(window.ethereum);
let signer;
let contract;

const contractAddress = "0xc2355e74dacfc2df426573a3e47083ba2ba70988"; 
const abi = [
  
    {
        "inputs": [],
        "stateMutability": "nonpayable",
        "type": "constructor"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "internalType": "address",
                "name": "account",
                "type": "address"
            },
            {
                "indexed": false,
                "internalType": "uint256",
                "name": "amount",
                "type": "uint256"
            }
        ],
        "name": "Deposit",
        "type": "event"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "internalType": "address",
                "name": "account",
                "type": "address"
            },
            {
                "indexed": false,
                "internalType": "uint256",
                "name": "amount",
                "type": "uint256"
            }
        ],
        "name": "Withdrawal",
        "type": "event"
    },
    {
        "inputs": [],
        "name": "deposit",
        "outputs": [],
        "stateMutability": "payable",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getBalance",
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
        "inputs": [
            {
                "internalType": "uint256",
                "name": "amount",
                "type": "uint256"
            }
        ],
        "name": "withdraw",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    }
];

async function connectWallet() {
    try {
        await provider.send("eth_requestAccounts", []);
        signer = provider.getSigner();
        contract = new ethers.Contract(contractAddress, abi, signer);
        document.getElementById("connectWallet").innerHTML = `<p>Connected: ${await signer.getAddress()}</p>`;
        console.log("Wallet connected successfully!");
    } catch (error) {
        console.error("Error connecting wallet:", error);
        alert("Failed to connect wallet. Check the console for details.");
    }
}

async function deposit() {
    try {
        const amount = document.getElementById("depositAmount").value;
        const tx = await contract.deposit({ value: ethers.utils.parseEther(amount) });
        await tx.wait();
        alert("Deposit successful!");
        console.log("Deposit transaction:", tx);
    } catch (error) {
        console.error("Error depositing funds:", error);
        alert("Failed to deposit. Check the console for details.");
    }
}

async function withdraw() {
    try {
        const amount = document.getElementById("withdrawAmount").value;
        const tx = await contract.withdraw(ethers.utils.parseEther(amount));
        await tx.wait();
        alert("Withdrawal successful!");
        console.log("Withdrawal transaction:", tx);
    } catch (error) {
        console.error("Error withdrawing funds:", error);
        alert("Failed to withdraw. Check the console for details.");
    }
}

async function checkBalance() {
    try {
        const balance = await contract.getBalance();
        document.getElementById("balanceDisplay").innerText = `Your balance: ${ethers.utils.formatEther(balance)} ETH`;
    } catch (error) {
        console.error("Error checking balance:", error);
        alert("Failed to check balance. Check the console for details.");
    }
}

// Add event listeners
document.getElementById("connectWalletBtn").addEventListener("click", connectWallet);
document.getElementById("depositBtn").addEventListener("click", deposit);
document.getElementById("withdrawBtn").addEventListener("click", withdraw);
document.getElementById("checkBalanceBtn").addEventListener("click", checkBalance);