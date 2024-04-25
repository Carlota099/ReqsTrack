// SPDX-License-Identifier: GPL-3.0

//solo llos stakeholders usaran este smart contract


pragma solidity >=0.8.2 <0.9.0;

import "./Requirement.sol";

contract RequirementCreation {

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
}