# **Secure Multi-Currency Wallet** 
The contract allows users to store and manage various digital assets, including cryptocurrencies (ERC-20 tokens), NFTs (ERC-721), and potentially other assets, such as ERC-1155 tokens. This contract ensures secure storage, transaction, and transfer functionalities while keeping a user-friendly approach for managing different asset types.

The wallet will include:
1. **ERC-20 Token Support**: Allowing users to store and transfer ERC-20 tokens.
2. **ERC-721 (NFT) Support**: Allowing users to store and transfer ERC-721 tokens (NFTs).
3. **Native Token (ETH) Support**: Allowing users to store and send native Ethereum tokens (ETH).
4. **Secure Access Control**: Implementing access control mechanisms for users to manage their assets securely.
5. **Transaction History (Optional)**: Tracking transactions for users (though this would typically require off-chain storage).
6. **Reentrancy Protection**: Ensuring secure transfer of assets to avoid reentrancy attacks.

### Key Features:

1. **Owner Control**: 
   - Only the owner (set during contract deployment) has the authority to withdraw funds or transfer tokens on behalf of users. This ensures that only the authorized wallet holder can perform sensitive operations, such as withdrawing funds or transferring tokens.

2. **Ether Storage**:
   - Users can deposit ETH into the wallet. The contract keeps track of the balance and allows users to withdraw their ETH.

3. **ERC-20 Token Storage**:
   - The wallet supports ERC-20 tokens. Users can deposit and withdraw ERC-20 tokens. The contract uses the `IERC20` interface from OpenZeppelin to interact with ERC-20 compliant tokens.

4. **ERC-721 (NFT) Storage**:
   - Users can deposit and withdraw ERC-721 tokens (NFTs). The contract ensures that each user’s NFTs are stored securely within the wallet, and they can only withdraw their own NFTs.

5. **Non-Reentrancy**:
   - The `nonReentrant` modifier from the `ReentrancyGuard` contract prevents reentrancy attacks when performing token transfers or withdrawals.

6. **Transaction Events**:
   - Events are emitted for all deposits and withdrawals, including ETH, ERC-20 tokens, and ERC-721 tokens, ensuring that all actions are transparently logged.

7. **Security**:
   - The contract uses access control via `onlyOwner` modifiers to protect sensitive operations like withdrawals and transfers.
   - The `nonReentrant` modifier ensures that reentrancy attacks, which can exploit recursive function calls to drain funds, are avoided.

### Functions Breakdown:

1. **`depositETH()`**: Allows the user to deposit ETH into the wallet.
2. **`withdrawETH()`**: Allows the owner to withdraw ETH from the wallet.
3. **`depositERC20()`**: Allows the user to deposit ERC-20 tokens.
4. **`withdrawERC20()`**: Allows the user to withdraw ERC-20 tokens from the wallet.
5. **`depositERC721()`**: Allows the user to deposit an ERC-721 token (NFT) into the wallet.
6. **`withdrawERC721()`**: Allows the user to withdraw an ERC-721 token (NFT).
7. **`getERC20Balance()`**: Allows the user to check their ERC-20 token balance in the wallet.
8. **`checkERC721Ownership()`**: Allows the user to check if they own a specific ERC-721 token in the wallet.
9. **`getETHBalance()`**: Allows the user to check the ETH balance in the wallet.
10. **`transferETH()`**: Allows the owner to transfer ETH to another address.
11. **`transferERC20()`**: Allows the owner to transfer ERC-20 tokens to another address.
12. **`transferERC721()`**: Allows the owner to transfer ERC-721 tokens to another address.

### Example Use Case:

1. **Creating a Wallet**:
   - When a user deploys the contract or interacts with it, they will become the **owner** of the wallet.

2. **Depositing Funds**:
   - Users can deposit their ETH or ERC-20 tokens into the wallet for safekeeping.
   - Example: `wallet.depositETH{value: 1 ether}` will deposit 1 ETH into the wallet.

3. **Withdrawing Funds**:
   - The wallet owner can withdraw the funds, either in ETH or ERC-20 tokens, by calling `withdrawETH` or `withdrawERC20`.

4. **Storing NFTs**:
   - Users can also store their NFTs in the wallet by calling `depositERC721` with the appropriate token ID.

5. **Transferring Assets**:
   - The wallet owner can transfer tokens or NFTs to other addresses using `transferETH`, `transferERC20`, or `transferERC721`.

### Conclusion:

This **Secure Multi-Currency Wallet** contract provides a flexible and secure way to store, manage, and transfer a variety of digital assets, including ETH, ERC-20 tokens, and ERC-721 tokens (NFTs). By using Solidity's built-in security features like the `ReentrancyGuard` and the `onlyOwner` modifier, this contract is designed for safe interaction with digital assets.