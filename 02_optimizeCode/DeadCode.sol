//SPDX-License-Identifier: Unlicense
pragma solidity >=0.5.0 <0.9.0;

contract deadCode {
    function find(uint256 x) public pure returns (uint256) {
        // one if is useless
        if (x > 2) {
            return x;
        }
        return 0;
    }
}
