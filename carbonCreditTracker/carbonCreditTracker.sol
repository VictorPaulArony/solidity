// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CarbonCreditTracker {

    address public admin;  // Admin address that has control over issuing carbon credits
    uint256 public totalCarbonCredits;  // Total carbon credits in circulation

    struct Business {
        uint256 carbonCredits;
        bool registered;
        string businessName;
        address businessAddress;
    }

    mapping(address => Business) public businesses;  // Mapping of businesses to their details
    mapping(address => uint256) public balances;  // Track each address's balance of carbon credits

    event CarbonCreditsIssued(address indexed businessAddress, uint256 amount);
    event CarbonCreditsTransferred(address indexed from, address indexed to, uint256 amount);
    event CarbonCreditsBurned(address indexed businessAddress, uint256 amount);
    event BusinessRegistered(address indexed businessAddress, string businessName);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyRegisteredBusiness() {
        require(businesses[msg.sender].registered, "Only registered businesses can interact");
        _;
    }

    modifier onlySufficientCredits(uint256 amount) {
        require(balances[msg.sender] >= amount, "Insufficient carbon credits");
        _;
    }

    constructor() {
        admin = msg.sender;  // Set the admin as the contract deployer
        totalCarbonCredits = 0;
    }

    // Register a new business
    function registerBusiness(string memory _businessName) public {
        require(!businesses[msg.sender].registered, "Business already registered");
        businesses[msg.sender] = Business({
            carbonCredits: 0,
            registered: true,
            businessName: _businessName,
            businessAddress: msg.sender
        });

        emit BusinessRegistered(msg.sender, _businessName);
    }

    // Admin function to issue carbon credits to a registered business
    function issueCarbonCredits(address _businessAddress, uint256 _amount) public onlyAdmin {
        require(businesses[_businessAddress].registered, "Business not registered");
        businesses[_businessAddress].carbonCredits += _amount;
        balances[_businessAddress] += _amount;
        totalCarbonCredits += _amount;

        emit CarbonCreditsIssued(_businessAddress, _amount);
    }

    // Business can transfer carbon credits to another business
    function transferCarbonCredits(address _to, uint256 _amount) public onlyRegisteredBusiness onlySufficientCredits(_amount) {
        require(businesses[_to].registered, "Recipient is not a registered business");
        
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;

        emit CarbonCreditsTransferred(msg.sender, _to, _amount);
    }

    // Admin can burn unused carbon credits to ensure they are not oversupplied
    function burnCarbonCredits(uint256 _amount) public onlyAdmin {
        require(totalCarbonCredits >= _amount, "Cannot burn more credits than in circulation");
        totalCarbonCredits -= _amount;

        emit CarbonCreditsBurned(msg.sender, _amount);
    }

    // Get the balance of carbon credits for a specific business
    function getCarbonCreditBalance(address _businessAddress) public view returns (uint256) {
        return balances[_businessAddress];
    }

    // A function to allow businesses to claim carbon credits for their sustainable practices
    // For simplicity, assume this is called after some external verification or audit
    function claimCarbonCredits(uint256 _amount) public onlyRegisteredBusiness {
        // In real-world use, this would likely require more complex logic 
        // to verify actual carbon offset activities.

        // Let's simulate an approval after verification by admin or external auditors:
        require(_amount > 0, "Amount must be greater than zero");

        // Admin needs to approve or verify that the business has sustainable practices
        businesses[msg.sender].carbonCredits += _amount;
        balances[msg.sender] += _amount;
        totalCarbonCredits += _amount;

        emit CarbonCreditsIssued(msg.sender, _amount);
    }

    // Helper function to check if a business is registered
    function isRegisteredBusiness(address _businessAddress) public view returns (bool) {
        return businesses[_businessAddress].registered;
    }

    // Fetch business details by address
    function getBusinessDetails(address _businessAddress) public view returns (string memory, uint256) {
        require(businesses[_businessAddress].registered, "Business not registered");
        return (businesses[_businessAddress].businessName, businesses[_businessAddress].carbonCredits);
    }
}
