// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract RequirementsManagement {
    uint256 numreqs;
    struct Requirement {
        uint256 id; 
        string name;  
        string description;
        string status;
        bool result;   
    }

    constructor(){
        numreqs = 0;
    }
}

contract createRequirements{ 

    mapping(uint256 => Requirement) requirements;

    function newRequirement(string memory name_, string memory description_) public{
        requirements[numreqs] = new Requirement(numreqs, name_, description_, "", false);
        numreqs++;
    }


}