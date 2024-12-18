// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//contract to loop through numbers
contract ForLoop{
    //define an array to sotore the numbers
    uint[] public arr;

    //function to loop through numbers and store them in an array
    function getForLoop() public returns(uint[] memory){
        for(uint i = 1; i <= 10; i++){
            arr.push(i);
        }
        return arr;
    }
}