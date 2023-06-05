// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract optimize {
    function repeatedComputations() public pure returns (uint256) {
        uint256 a = 2;
        uint256 b = 3;

        return a + b;
        //  require(b > a, "b is not greater than a");

        // 3 will always be greater than 2 hence the require statement is useless
    }
}
