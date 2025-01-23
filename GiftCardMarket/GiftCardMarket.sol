// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ERC-20 interface for interaction with the token
interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract GiftCardMarket {

    address public admin;  // Admin address, could be the deployer or a DAO.
    IERC20 public token;  // ERC-20 token used for redemption.
    
    uint256 public totalGiftCardsIssued;  // Track the total gift cards issued by businesses

    // Struct representing a gift card
    struct GiftCard {
        uint256 id;
        address business;
        uint256 value;  // Value of the gift card in the ERC-20 token
        uint256 redemptionTimestamp;  // Timestamp of when the card is redeemed
        bool redeemed;  // Flag to check if the card has been redeemed
    }

    // Mapping to track gift cards by their ID
    mapping(uint256 => GiftCard) public giftCards;

    // Mapping to track the gift cards owned by each customer (address -> gift card IDs)
    mapping(address => uint256[]) public customerGiftCards;

    event GiftCardIssued(uint256 indexed giftCardId, address indexed business, uint256 value);
    event GiftCardRedeemed(uint256 indexed giftCardId, address indexed customer, uint256 value);
    event GiftCardTransferred(uint256 indexed giftCardId, address indexed from, address indexed to);

    modifier onlyBusiness() {
        require(msg.sender != admin, "Admin cannot issue gift cards");
        _;
    }

    modifier onlyRedeemable(uint256 _giftCardId) {
        require(!giftCards[_giftCardId].redeemed, "This gift card has already been redeemed");
        require(giftCards[_giftCardId].value > 0, "Invalid gift card value");
        _;
    }

    modifier onlyCustomerWithGiftCard(uint256 _giftCardId) {
        bool found = false;
        for (uint256 i = 0; i < customerGiftCards[msg.sender].length; i++) {
            if (customerGiftCards[msg.sender][i] == _giftCardId) {
                found = true;
                break;
            }
        }
        require(found, "You don't own this gift card");
        _;
    }

    constructor(address _tokenAddress) {
        admin = msg.sender;
        token = IERC20(_tokenAddress);  // ERC-20 token used for redemption
    }

    // Issue a new gift card for a business
    function issueGiftCard(address _business, uint256 _value) external onlyBusiness returns (uint256) {
        require(_value > 0, "Gift card value must be greater than zero");

        uint256 newGiftCardId = totalGiftCardsIssued + 1;
        giftCards[newGiftCardId] = GiftCard({
            id: newGiftCardId,
            business: _business,
            value: _value,
            redemptionTimestamp: 0,
            redeemed: false
        });

        totalGiftCardsIssued++;

        // Associate the new gift card with the business and customer
        customerGiftCards[_business].push(newGiftCardId);

        emit GiftCardIssued(newGiftCardId, _business, _value);
        return newGiftCardId;
    }

    // Redeem a gift card for ERC-20 tokens
    function redeemGiftCard(uint256 _giftCardId) external onlyRedeemable(_giftCardId) {
        GiftCard storage card = giftCards[_giftCardId];

        require(token.balanceOf(address(this)) >= card.value, "Insufficient contract balance to redeem gift card");

        // Mark the card as redeemed
        card.redeemed = true;
        card.redemptionTimestamp = block.timestamp;

        // Transfer the ERC-20 tokens to the customer
        require(token.transfer(msg.sender, card.value), "Token transfer failed");

        // Remove the gift card from the customer's list
        removeCustomerGiftCard(msg.sender, _giftCardId);

        emit GiftCardRedeemed(_giftCardId, msg.sender, card.value);
    }

    // Transfer gift card to another customer
    function transferGiftCard(uint256 _giftCardId, address _to) external onlyCustomerWithGiftCard(_giftCardId) {
        GiftCard storage card = giftCards[_giftCardId];
        require(!card.redeemed, "Gift card has already been redeemed");

        // Remove the gift card from the sender's list
        removeCustomerGiftCard(msg.sender, _giftCardId);

        // Add the gift card to the recipient's list
        customerGiftCards[_to].push(_giftCardId);

        emit GiftCardTransferred(_giftCardId, msg.sender, _to);
    }

    // Internal function to remove a gift card from a customer's list
    function removeCustomerGiftCard(address _customer, uint256 _giftCardId) internal {
        uint256[] storage customerCards = customerGiftCards[_customer];
        for (uint256 i = 0; i < customerCards.length; i++) {
            if (customerCards[i] == _giftCardId) {
                customerCards[i] = customerCards[customerCards.length - 1];
                customerCards.pop();
                break;
            }
        }
    }

    // Admin can withdraw any tokens that are in the contract's balance
    function adminWithdrawTokens(uint256 _amount) external {
        require(msg.sender == admin, "Only admin can withdraw");
        require(token.balanceOf(address(this)) >= _amount, "Insufficient contract balance");

        require(token.transfer(admin, _amount), "Token withdrawal failed");
    }

    // Get all gift card IDs owned by a customer
    function getCustomerGiftCards(address _customer) external view returns (uint256[] memory) {
        return customerGiftCards[_customer];
    }

    // Get the details of a specific gift card
    function getGiftCardDetails(uint256 _giftCardId) external view returns (GiftCard memory) {
        return giftCards[_giftCardId];
    }
}
