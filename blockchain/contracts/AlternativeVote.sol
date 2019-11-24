pragma solidity >=0.4.21 < 0.6.0;

import "./Ownable.sol";


contract AlternativeVote is Ownable{
    Candidates[5] public candidates;
    Candidates[5] public votesList;

    struct Candidates{
        string firstName;
        string lastName;
        string description;
        address candidate;
    }
    
    constructor() public {
    }
    
    function giveVotesList(Candidates[5] _votesList) public {
        this.votesList = _votesList;
    }
    
}