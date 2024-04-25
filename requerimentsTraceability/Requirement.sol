// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Requirement {
    uint256 id; 
    string name;  
    string description;
    string requestedBy;     //new
    uint256[] testIds;      //Tests that have to be made to approve this requirement.
    enum Status {Sent, Created, Testing, Finished}
    Status public state;
    bool result = false;        //always false until its succesful=OK

    address public owner;
    mapping(address => bool) public developers;

    uint256 numreqs;

    constructor(uint256 _id, string memory _name, string memory _description, address _owner){
        id = _id;
        name = _name;
        description = _description;
        state = Status.Sent; // Establecemos el estado inicial como "Sent"
        owner = _owner;
        developers[_owner] = true;
    }

    event RequerimentSent();
    event TestingRequeriment();
    event RequerimentOk();
    event RequerimentKo();

    modifier onlyOwner() {
        require(msg.sender == owner, "Solo el propietario puede realizar esta operacion");
        _;
    }

    modifier onlyDeveloper() {
        require(developers[msg.sender], "Solo los desarrolladores autorizados pueden realizar esta operacion");
        _;
    }

    function addDeveloper(address _developer) public onlyOwner {
        developers[_developer] = true;
    }

//revisar estoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
    modifier inState(Status _state) {
        require(state == _state, "Non-valid");
        _;
    }

//revisar si estas funciones hacen falta!
    function changeStatus(Status _newStatus) public onlyDeveloper {
        state = _newStatus;
    }

    function addTestId(uint256 _testId) public onlyDeveloper {
        testIds.push(_testId);
    }

    function getRequirementInfo() public view returns (uint256, string memory, string memory, uint256[] memory, Status) {
        return (id, name, description, testIds, state);
    }

    //the following 2 functions can only be done by developers

    function abortRequeriment() external{
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
