// SPDX-License-Identifier: GPL-3.0

//los developers usaran este para modificar i tal

pragma solidity >=0.8.2 <0.9.0;

import "./Requirement.sol";

contract RequirementManager {
    uint256 public numreqs;
    mapping(uint256 => Requirement) public requirements;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can do this");
        _;
    }

    function createRequirement(string memory _name, string memory _description) public onlyOwner returns (uint256) {
        numreqs++;
        requirements[numreqs] = new Requirement(numreqs, _name, _description, msg.sender);
        return numreqs;
    }

    function changeRequirementStatus(uint256 _requirementId, Requirement.Status _newStatus) public onlyOwner {
        Requirement requirement = requirements[_requirementId];
        requirement.changeStatus(_newStatus);
    }

    function getRequirementInfo(uint256 _requirementId) public view returns (uint256, string memory, string memory, uint256[] memory, Requirement.Status) {
        Requirement requirement = requirements[_requirementId];
        return requirement.getRequirementInfo();
    }
}