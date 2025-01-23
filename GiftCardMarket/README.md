# GiftCardMarket 
 The system will allow businesses to create gift cards tied to specific values, and customers will be able to redeem them for tokens (ERC-20).

The key features of this contract include:
1. **Business Issuance**: Businesses can create and issue gift cards with a defined value.
2. **Customer Redemption**: Customers can redeem gift cards for ERC-20 tokens.
3. **ERC-20 Integration**: The contract will interface with an ERC-20 token, where the gift card's value will be converted into tokens.
4. **Tracking and Transparency**: Both the business and the customer will be able to track the gift cards.

### Contract Breakdown:

1. **Admin and Token Address**:
   - The contract has an admin who can perform special actions like withdrawing tokens.
   - The contract works with an ERC-20 token (represented by the `IERC20` interface), which will be used for gift card redemptions.

2. **Gift Card Structure**:
   - The contract stores details of each gift card in the `GiftCard` struct, including:
     - **ID**: Unique identifier for each gift card.
     - **Business Address**: The address of the business that issued the card.
     - **Value**: The value of the gift card in ERC-20 tokens.
     - **Redemption Status**: Whether the gift card has been redeemed.
     - **Timestamp**: The time when the gift card was redeemed.

3. **Issuing Gift Cards**:
   - Businesses can issue gift cards using the `issueGiftCard` function. The issued gift card has a value specified in the ERC-20 token.

4. **Redeeming Gift Cards**:
   - Customers can redeem their gift cards for the specified amount of ERC-20 tokens via the `redeemGiftCard` function. The card is marked as redeemed and the tokens are transferred.

5. **Gift Card Transfer**:
   - Gift cards can be transferred between customers using the `transferGiftCard` function.

6. **Tracking Gift Cards**:
   - Customers can track their owned gift cards through the `getCustomerGiftCards` function. 
   - The contract stores an array of gift card IDs for each customer and uses this data to facilitate transfers and redemptions.

7. **Admin Withdrawals**:
   - The admin has the ability to withdraw ERC-20 tokens from the contract using the `adminWithdrawTokens` function.

### Further Considerations:
- **Security**: Ensure that only valid businesses can issue gift cards and that redemption logic is secure.
- **Gas Efficiency**: The contract is designed to minimize gas usage, especially with the transfer and removal of gift cards.
- **Token Balances**: The contract will only allow redemptions if it has enough ERC-20 tokens in its balance to meet the value of all redeeming gift cards.


