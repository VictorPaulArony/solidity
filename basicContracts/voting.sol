// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    mapping(uint256 => Candidate) public candidates;
    mapping(address => bool) public voters;
    uint256 public candidatesCount;
    uint256 public totalVotes;

    // Add a candidate to the election
    function addCandidate(string memory name) public {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, name, 0);
    }

    // Vote for a candidate
    function vote(uint256 candidateId) public {
        require(!voters[msg.sender], "You have already voted");
        require(candidateId > 0 && candidateId <= candidatesCount, "Invalid candidate");

        voters[msg.sender] = true;
        candidates[candidateId].voteCount++;
        totalVotes++;
    }

    // Get the vote count for a candidate
    function getVotes(uint256 candidateId) public view returns (uint256) {
        return candidates[candidateId].voteCount;
    }
}
