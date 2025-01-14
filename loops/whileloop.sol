//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//contract to explain the while loop
contract WhileLoop {
    uint public total;

     //function to add nums while the value is above the condition
    function addWhile(uint _num) public {
        total = 0;
        uint i = 0;
        while(i < _num) {
            total+= i;
            i++;
        }
        
    }

    function getTotalSum() public view returns (uint) {
        return total;
    }

    //function to explain the do while loop
    uint[] public arr;

    //function to add numbers in an array as long as the condition is valid
    function addToArray(uint _num) public {
        uint count = 0;

        do {
            arr.push(count);
            count++;
        } while (count < _num);
    
    }

    //function to check the lenth of the array
    function getLenth() public view returns (uint) {
        return arr.length;
    }

    //function to get the array elements
    function getArrayElements() public view returns (uint[] memory) {
        return arr;
    }
}
