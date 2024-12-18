// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

//cntraact to add two numbers
contract Sum{
    uint public num1;
    uint public num2;
    uint public sum;


    //function to set the numbers for summing
    function setSum(uint x, uint y )public{
        num1 = x;
        num2 = y;
        sum = num2 + num1;
    }

    //function to add the two numbers 
    function getSum() public view  returns(uint ){
        return sum;
    }


}