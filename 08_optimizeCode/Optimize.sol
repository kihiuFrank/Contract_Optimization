// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract optimize {
    //make them constant because we know they are not changing
    uint256 constant a = 4;
    uint256 constant b = 5;

    function repeatedComputations(uint256 x) external pure returns (uint256) {
        uint256 sum;
        uint256 _a = a; // only one state read
        uint256 _b = b; // only one state read
        for (uint256 i = 0; i <= x; i++) {
            sum = sum + _a * _b;
        }
        return sum;
    }
}

// Unoptimized - 30618 gas
// after optimization - 25119  gas
// declaring both variables as constants
// using local variables to allow only one state read
