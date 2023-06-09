// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract optimize {
    uint256 public num;

    // Solution 1
    function expensiveLoop(uint256 x) public returns (uint256) {
        // for (uint256 i = 0; i < x; i++) {
        //     // x = 10 -> 56,870 gas
        //     // x = 100 -> 98,374 gas
        //     // x = 1000 -> 710,073 gas
        //     // x = 10000 -> 6,826,923 gas
        //     num += 1;
        // }

        // x = 10 -> 50,719 gas
        // x = 100 -> 31,054 gas
        // x = 1000 -> 31,068 gas
        // x = 10000 -> 31,068 gas
        return num = num + x;
    }

    // solution 2
    function sol(uint256 x) public {
        uint256 _num = num; // one state read

        for (uint256 i = 0; i < x; i++) {
            _num += 1; // local reads and writes
        }
        num = _num; // one state write
    }
}
