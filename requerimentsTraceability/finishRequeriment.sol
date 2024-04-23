// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract finishRequeriment {

    function endRequeriment(uint256 id_) public {
        requirements[id_].result = true;
    }
}