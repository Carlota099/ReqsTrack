// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Requirements {
    
    uint256 public numreqs;
    
    enum Status {
        Sent, 
        InProcess, 
        Testing, 
        Finished
    }

    struct Requeriment {
        uint256 id; 
        string name;  
        string description;
        address requestedBy;     
        uint256[] testIds;      //Tests that have to be made to approve this requirement.
        Status state;
        string feedback;        //in case of KO or modifications, indicate here reasons/requests or comments
        bool result;        //always false until its succesful=OK
    }
        
    address public owner;
    mapping(uint256 => Requeriment) public requeriments;

    constructor(){
        owner = msg.sender;
        numreqs = 0;
    }

    event RequerimentSent(uint256 Reqid);
    event RequerimentModified(uint256 Reqid);
    event TestingRequeriment(uint256 Reqid);
    event RequerimentOk(uint256 Reqid);
    event RequerimentKo(uint256 Reqid);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can do this");
        _;
    }

    modifier inState(Status _state) {
        require(_state == _state, "Non-valid");
        _;
    }

    function createRequeriment(string memory _name, string memory _description) public {
        Requeriment storage req = requeriments[numreqs];
        req.id = numreqs;
        req.name = _name;
        req.description = _description;
        req.requestedBy = msg.sender;
        req.state = Status.Sent;
        req.result = false;
        numreqs ++;
        emit RequerimentSent(req.id);
    }

    function changeStatus(uint256 _requirementId) public {
        require(_requirementId < numreqs, "Requirement does not exist");

        Requeriment storage req = requeriments[_requirementId];
        // This passes the status to the next one
        req.state = Status((uint(req.state) + 1) % uint(Status.Finished) + 1);
        
        if(req.state == Status.Testing){
            emit TestingRequeriment(_requirementId);
        }
    }

    function addTest(uint256 _requirementId, uint256 _testId) public {
        require(_requirementId < numreqs, "Requirement does not exist");
        Requeriment storage req = requeriments[_requirementId];
        req.testIds.push(_testId);
    }

    function getRequirement(uint256 _requirementId) public view returns (uint256, string memory, string memory, uint256[] memory, Status) {
        return (requeriments[_requirementId].id, requeriments[_requirementId].name, requeriments[_requirementId].description, requeriments[_requirementId].testIds, requeriments[_requirementId].state);
    }

    function listRequirements() public view returns (uint256[] memory, string[] memory) {
        uint256[] memory ids = new uint256[](numreqs);
        string[] memory names = new string[](numreqs);
    
        for (uint256 i = 0; i < numreqs; i++) {
            ids[i] = requeriments[i].id;
            names[i] = requeriments[i].name;
        }
        return (ids, names);
    }

    function abortRequeriment(uint256 _requirementId) external {
        require(requeriments[_requirementId].state == Status.Testing, "You can only abort a requirement that is being tested");
        emit RequerimentKo(_requirementId);
        changeStatus(_requirementId);    
    }

    function aproveRequeriment(uint256 _requirementId) external {
        Requeriment storage req = requeriments[_requirementId];
        require(req.state == Status.Testing, "You can only approve a requirement that is being tested");    
        req.state = Status.Finished;
        req.result = true;
        emit RequerimentOk(_requirementId);
    }

    function modifyRequirement(uint256 _requirementId, string memory _description) public{
        require(_requirementId < numreqs, "Requirement does not exist");
        Requeriment storage req = requeriments[_requirementId];
        req.description = _description;
        emit RequerimentModified(_requirementId);
        
        if(req.state==Status.Testing || req.state==Status.Finished){
            req.state = Status.InProcess;
        }
    }

    function addFeedback(uint256 _requirementId, string memory _feedback) public{
        require(_requirementId < numreqs, "Requirement does not exist");
        Requeriment storage req = requeriments[_requirementId];
        req.feedback = _feedback; 
    }
}
