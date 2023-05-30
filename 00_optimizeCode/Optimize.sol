// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract optimize {
    function setCompleted() public pure returns (uint256) {
        uint256 a;
        uint256 b;
        uint256 c;
        uint256 d;
        uint256 x;
        c = a * b;
        x = a;
        d = x * b + 4;
        return d;
    }
}
