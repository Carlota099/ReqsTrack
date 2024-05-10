// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./Requirements.sol";

contract Tests {

    uint256 public numtests;

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
        numtests = 0;
    }

    event TestCreated();
    event FailedTest();
    event TestSucceed();

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can do this");
        _;
    }

    function createTest(string memory _name, string memory _description) public {
        tests[numtests].id = numtests;
        tests[numtests].name = _name;
        tests[numtests].description = _description;
        numtests++;
        emit TestCreated();
    }

    function modifyTest(uint256 _testId) public {

    }

    function addResult(uint256 _testId, string memory _result) public {
        tests[_testId].expectedResult = _result;
    }

    function executeTest() public{

    }

    function getTest(uint256 _testId) public view returns (uint256,string memory,string memory,string memory,string memory) {
        return (tests[_testId].id, tests[_testId].name, tests[_testId].description, tests[_testId].expectedResult, tests[_testId].currentResult);
    }

    function listTests() public view returns (uint256[] memory, string[] memory){
        uint256[] memory ids = new uint256[](numtests);
        string[] memory names = new string[](numtests);
    
        for (uint256 i = 0; i < numtests; i++) {
            ids[i] = tests[i].id;
            names[i] = tests[i].name;
        }
        return (ids, names);
    }

}