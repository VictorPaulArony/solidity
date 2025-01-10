//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//contract for a for loop implemantation
contract ForLoop{
    uint public total;
    //function to get the total of all the numbers entered 
     function addforloopElememts(uint _num) public {
        total = 0;
        for (uint i = 1; i <= _num; i++){
            total+= i;
        }
    }

    //function to get the total of the elements added
    function getTotalSum() public  view returns(uint){
        return total;
    }
    
    uint[] public arr;
    //function to store all the numbers entered in 
    function getArray(uint _num) public returns(uint[] memory){
        for(uint i = 1; i <= _num; i++){
            arr.push(i);
        }
        return arr;
    }

    //function to check the lenth of the array 
    function getLenth() public view returns(uint ){
        return arr.length;
    }

      //function to get the array elements 
    function getArrayElements() public view returns(uint[] memory){
        return arr;
    }
    

}