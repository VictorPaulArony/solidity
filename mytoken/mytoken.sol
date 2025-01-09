// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//contract to create my token for miting and transfaring
contract MyToken{
    //MyToken attributes
    string public name = "MyToken";
    string public symbol = "MTK";
    uint public  totalSupply;
    uint public decimals = 18;//just like most coins have
    
    mapping (address => uint) public balance;
    //mapping to store the allowance for token trasfer on behalf of another address
    mapping(address => mapping(address => uint)) public allowance;

    //events of the contract definitions
    event Transfer(address indexed from, address indexed to, uint amount);
    event Mint(address indexed to, uint value);
    event Approval(address indexed  owner, address indexed  spender, uint value);

    //difinition of the constractor to set initial supply for the contract creator
    constructor(uint _initialSupply){
        mint(msg.sender, _initialSupply);
    }

    //function to mint new token and increase total supply
    function mint(address _to, uint _value) public {
        require(
            _value > 0,
            "MTK: The aount should be more than 0: "
        );
        //updating the state of the function
        totalSupply += _value;
        balance[_to] += _value;

        //emiting the event (logging the minting event)
        emit Mint(_to, _value);

    }

    //function to approve another address to spend token
    function approval(address _spender, uint _value) public returns (bool successful){
        require(
            _value > 0,
            "The amount should be more than 0:"
        );
        //updating the state of the contract
        allowance[msg.sender][_spender] = _value;

        //log the approval event 
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    //function to allowe transfer of tokens btwn teo addresses
    function transfer(address _to, uint _amount) public returns (bool successful) {
        require(
            _to != address(0),
            "MTK: Transfer to a nil adddres, provide an address to continue "
        );
        require(
            balance[msg.sender] >= _amount,
            "MTK: Insufficient aount in your account"
        );

        //updating the state of the function
        balance[msg.sender] -= _amount;
        balance[_to] += _amount;

        //logging the event for the transfer function
        emit Transfer(msg.sender, _to, _amount);
        return  true;
    }

      // Function to transfer tokens on behalf of another address (after approval)
    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
        require(
            _from != address(0), 
            "MTK: transfer from the zero address"
        );
        require(
            _to != address(0),
            "MTK: transfer to the zero address"
        );
        require(
            balance[_from] >= _amount,
             "MTK: insufficient balance"
        );
        require(
            allowance[_from][msg.sender] >= _amount,
            "MTK: allowance exceeded"
        );

        //updating the state of the function
        balance[_from] -= _amount;
        balance[_to] += _amount;
        allowance[_from][msg.sender] -= _amount;

        // Log the transfer event of the function
        emit Transfer(_from, _to, _amount); 
        return true;
    }

    //function to check the remaonng allowance of an account
    function allowanceOf(address _owner, address _spender) public view returns (uint remaining){
        return allowance[_owner][_spender];
    }

}