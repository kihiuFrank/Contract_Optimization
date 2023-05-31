// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract identify {
    function call(uint256 x) public pure returns (bool) {
        //1
        // return x <= 9;
        return x < 10; //instead of using <= we can work only with <
    }
}
