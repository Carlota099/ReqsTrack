// SPDX-License-Identifier: GPL-3.0

//los developers usaran este para modificar i tal

pragma solidity >=0.8.2 <0.9.0;

import "./Requirements.sol";

contract RequirementManagement {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can do this");
        _;
    }

    function changeRequirementStatus(uint256 _requirementId, Requirement.Status _newStatus) public onlyOwner {
        Requirement requirement = requirements[_requirementId];
        requirement.changeStatus(_newStatus);
    }

    function getRequirementInfo(uint256 _requirementId) public view returns (uint256, string memory, string memory, uint256[] memory, Requirement.Status) {
        Requirement requirement = requirements[_requirementId];
        return requirement.getRequirementInfo();
    }

    function addTest(uint256 _requirementId, uint256 _testId) public onlyOwner  {
        Requirement requirement = requirements[_requirementId];
        requirement.addTestId(_testId);
        //Maybe it should be linked in both directions
    }

    function linkTest()


//function createRequeriment()
//
//function modifyRequeriment
//function to track the req
//function to list all requeriments with the ID (to make easier the creation of a req)


}