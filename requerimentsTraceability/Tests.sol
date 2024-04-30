// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./Requirements.sol";

contract Tests {

    struct Test {
        uint256 id; 
        string name;  
        string description;
        string expectedResult;
        string currentResult;
    }

    address public owner;
    mapping(uint256 => Test) public tests;

    constructor() {
        owner = msg.sender;
        uint256 numtests = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can do this");
        _;
    }

    function createTest(string memory _name, string memory _description) public onlyOwner {
        tests[numtests].id = numtests;
        tests[numtests].name = _name;
        tests[numtests].description = _description;
    }
}