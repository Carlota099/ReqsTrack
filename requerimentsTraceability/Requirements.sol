// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Requirements {
    
    struct Requeriment {
        uint256 id; 
        string name;  
        string description;
        string requestedBy;     //new
        uint256[] testIds;      //Tests that have to be made to approve this requirement.
        enum Status {Sent, Created, Testing, Finished}
        Status public state;
        string feedback;        //in case of KO or modifications, indicate here reasons/requests
        bool result;        //always false until its succesful=OK
    }
        
    address public owner;
    mapping(uint256 => Requeriment) public requeriments;
    //mapping(address => bool) public developers;

    constructor(){
        owner = msg.sender;
        uint256 numreqs = 0;
    }

    event RequerimentSent();
    event RequerimentSatisfied();
    event TestingRequeriment();
    event RequerimentOk();
    event RequerimentKo();

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can do this");
        _;
    }

//revisar estoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
    modifier inState(Status _state) {
        require(state == _state, "Non-valid");
        _;
    }

    function createRequeriment(string _name, string _description) onlyOwner {
        requeriments[numreqs].id = numreqs;
        requeriments[numreqs].name = _name;
        requeriments[numreqs].description = _description;
        requeriments[numreqs].requestedBy = msg.sender;
        requeriments[numreqs].state = Sent;
        requeriments[numreqs].result = false;
        numreqs ++;
    }

    function changeStatus(Status _newStatus) public {
        state = _newStatus;
    }

    function addTestId(uint256 _testId) public {
        testIds.push(_testId);
    }

    function getRequirementInfo() public view returns (uint256, string memory, string memory, uint256[] memory, Status) {
        return (id, name, description, testIds, state);
    }

    //the following 2 functions can only be done by developers

    function abortRequeriment() external {
        require(state == Status.Testing, "You can only abort a requirement that is being tested");
        emit RequerimentKo();
        state = Status.Finished;
    }

    function aproveRequeriment() external {
        require(state == Status.Testing, "You can only approve a requirement that is being tested");    
        emit RequerimentOk();
        state = Status.Finished;
        result = true;
    }
}
