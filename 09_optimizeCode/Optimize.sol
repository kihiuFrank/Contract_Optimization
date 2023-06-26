// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract lib {
    // We don't need a library to do a simple addition. It's not gas effecient.
    // import './SafeMath.sol' as SafeMath;

    function safeAdd(uint a, uint b) public pure returns (uint) {
        uint c = a + b;
        require(c >= a, "addition overflow check");
        return c;
    }
}
