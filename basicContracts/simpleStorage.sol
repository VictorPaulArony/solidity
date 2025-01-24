// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 public storedValue;

    // Set a new value
    function set(uint256 value) public {
        storedValue = value;
    }

    // Get the stored value
    function get() public view returns (uint256) {
        return storedValue;
    }
}
