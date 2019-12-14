pragma solidity >=0.4.21 < 0.6.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";


contract AlternativeVote is Ownable {

    /*********************
    *       TYPES        *
    *********************/
    enum Phase {
        REGISTER,
        OPEN,
        CLOSED
    }

    /*********************
    *      VARIABLES     *
    *********************/
    Phase private _currentPhase;
    /**
        liste d'adresse des candidats
        candidatesList = ["0xJHJK13KJX", "0xLKJKHK3KJX"]
     */
    address[] private _candidatesList;
    /**
        {
            liste_votants : [liste_candidat]
            "0xKJHKJH": ["0xJHJK13KJX", "0xLKJKHK3KJX"],
            "0xJBHJ256KJH" : ["0xLKJKHK3KJX", "0xJHJK13KJX"]
        }
     */
    mapping(address => address[]) private _votersAddressMapping;
    /**
        liste_votants : ["0xKJHKJH", "0xJBHJ256KJH"] pour parser le mapping
     */
    address[] private _votersAddress;

    /*********************
    *       EVENTS       *
    *********************/
    event PhaseChange(Phase newPhase);
    event CandidateAdded(address candidate);
    event ResetVote();

    /*********************
    *      FUNCTIONS     *
    *********************/

    constructor() public {
        _currentPhase = Phase.REGISTER;
    }

    function registerCandidate() external onlyRegisterPhase {
        for(uint i = 0; i < _candidatesList.length; i++) {
            require(_candidatesList[i] != msg.sender, "User is already a candidate");
        }
        _candidatesList.push(msg.sender);
        emit CandidateAdded(msg.sender);
    }

    /**
        Permet à un utilisateur de declarer son vote
        Son vote est un tableau avec tous les candidats
        classé de son préféré à son pire
     */
    function giveVotesList(address[] memory _votesList) public onlyOpenPhase alreadyVoted {
        _votersAddressMapping[msg.sender] = _votesList;
        _votersAddress.push(msg.sender);
    }

    function setCurrentPhase(uint newPhase) public onlyOwner {
        _currentPhase = Phase(newPhase);
        emit PhaseChange(_currentPhase);
    }

    function resetVoteToDefault() external onlyOwner {
        _currentPhase = Phase.REGISTER;
        emit PhaseChange(_currentPhase);
        for(uint i = 0; i < _votersAddress.length; i++) {
            delete _votersAddressMapping[_votersAddress[i]];
        }
        delete _candidatesList;
        delete _votersAddress;
        emit ResetVote();
    }

    //calcule les résultats
    function processVotersAddressMapping() public onlyOwner {
        uint roundNumber = _candidatesList.length - 1;

        for(uint round = 0; round < roundNumber; round++) {
            for(uint voter = 0; voter < _votersAddress.length; voter++) {

            }
        }
    }

    // function setArrayForNextRound(uint[] storage array) internal returns(uint[] memory) {
    //     for(uint i = 0; i < array.length - 1; i++){
    //         array[i] = 0;
    //     }
    //     array.length--;
    //     return array;
    // }

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

    /*********************
    *       GETTER       *
    *********************/

    function getCandidatesList() external view returns(address[] memory){
        return _candidatesList;
    }

    function getCurrentPhase() external view returns(Phase) {
        return _currentPhase;
    }

    function getAlreadyVoted () external view returns(bool) {
        return _votersAddressMapping[msg.sender].length > 0;
    }

    function getUserVote() external view returns(address[] memory) {
        return _votersAddressMapping[msg.sender];
    }

    /*********************
    *   PURE FUNCTIONS   *
    *********************/

    /**
        @param array of uint
        @return index of smaller int in array
     */
    function smallest(uint[] memory array) internal pure returns(uint){
        uint min = 0;
        for (uint i = 1; i < array.length - 1; i++){
            if(array[i] < array[min]) min = i;
        }
        return min;
    }

    /*********************
    *      MODIFIERS     *
    *********************/

    modifier onlyRegisterPhase() {
        require(_currentPhase == Phase.REGISTER, "Current phase is not REGISTER");
        _;
    }

    modifier onlyOpenPhase() {
        require(_currentPhase == Phase.OPEN, "Current phase is not Open");
        _;
    }

    modifier alreadyVoted() {
        require(!(_votersAddressMapping[msg.sender].length > 0), "Already voted");
        _;
    }
}