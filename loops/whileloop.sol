//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//contract to explain the while loop
contract WhileLoop{
    uint public total;

    //function to add nums while the value is above the condition
    function addWhile(uint _num) public {
        total = 0;
        while(total < _num) {
            total+= _num;
        }
        
    }

     function getTotalSum() public  view returns(uint){
        return total;
    }


    //function to explain the do while loop
    uint[] public arr;

    //function to add numbers in an array as long as the condition is valid
    function addToArray(uint _num) public returns(uint[] memory){
        uint count = 0;

        do{
            arr.push(count);
            count++;
        }while(count < _num);
        return arr;
    }
}