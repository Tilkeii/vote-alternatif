pragma solidity >=0.4.21 < 0.6.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";


contract AlternativeVote is Ownable {
    Phase currentPhase;

    /**
        liste d'adresse des candidats
        candidatesList = ["0xJHJK13KJX", "0xLKJKHK3KJX"]
     */
    address[] candidatesList;
    /**
        {
            liste_votants : [liste_candidat]
            "0xKJHKJH": ["0xJHJK13KJX", "0xLKJKHK3KJX"],
            "0xJBHJ256KJH" : ["0xLKJKHK3KJX", "0xJHJK13KJX"]
        }
     */
    mapping(address => address[]) votersAddressMapping;
    // liste_votants : ["0xKJHKJH", "0xJBHJ256KJH"] pour parser le mapping
    address[] votersAddress;

    enum Phase {
        REGISTER,
        OPEN,
        CLOSED
    }

    constructor() public {
        currentPhase = Phase.REGISTER;
    }

    function registerCandidate() public onlyRegisterPhase {
        candidatesList.push(msg.sender);
    }

    /**
        Permet à un utilisateur de declarer son vote
        Son vote est un tableau avec tous les candidats
        classé de son préféré à son pire
     */
    function giveVotesList(address[] memory _votesList) public onlyOpenPhase {
        votersAddressMapping[msg.sender] = _votesList;
        votersAddress.push(msg.sender);
    }

    function closeVoteSession() public onlyOwner {
        currentPhase = Phase.CLOSED;
        processVotersAddressMapping();
    }

    //calcule les résultats
    function processVotersAddressMapping() internal {
        uint roundNumber = candidatesList.length;
        
        for(uint round = 0; round < roundNumber; round++) {
            for(uint voter = 0; voter < votersAddress.length; voter++) {

            }

        }

    }

    /**
        @param array of uint
        @return index of smaller int in array
     */
    function smallest(uint[] memory array) public returns(uint){
        uint min = 0;
        for (uint i = 1; i < array.length - 1; i++){
            if(array[i] < array[min]) min = i;
        }
        return min;
    }

    /**
        @param index of item to remove
        @param array of items
        @return array without the element at the given index
     */
    function remove(uint index, address[] storage array) internal returns(address[] memory) {
        if (index >= array.length) return array;

        for (uint i = index; i < array.length - 1; i++){
            array[i] = array[i + 1];
        }
        // delete array[array.length-1];
        array.length--;
        return array;
    }

    /**
        @param
        @return
     */
    function setArrayForNextRound(uint[] storage array) internal returns(uint[] memory) {
        for(uint i = 0; i < array.length - 1; i++){
            array[i] = 0;
        }
        array.length--;
        return array;
    }

    /**
    
     */

    //renvoie le vote de l'utilisateur
    // function getMyVote() public {

    // }

    modifier onlyRegisterPhase() {
        require(currentPhase == Phase.REGISTER, "Current phase is not REGISTER");
        _;
    }

    modifier onlyOpenPhase() {
        require(currentPhase == Phase.OPEN, "Current phase is not Open");
        _;
    }
    
    function getCandidatesList() public returns(address[] memory){
        return candidatesList;
    }
}