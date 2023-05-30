// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract optimize {
    function p5(uint256 x) external pure {
        uint256 m = 0;
        // uint256 v = 0;
        for (uint256 i = 0; i < x; i++) {
            m += i;
        }
        for (uint256 j = 0; j < x; j++) {
            m -= j;
        }
    }
}
