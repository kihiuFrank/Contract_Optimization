// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract optimize {
    uint256 a = 4;
    uint256 b = 5;

    function repeatedComputations(uint256 x) public view returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i <= x; i++) {
            sum = sum + a * b;
        }
        return sum;
    }

    //    uint256 a = 4;//make them constant
    // uint256 b = 5;  //use internal or external

    // function repeatedComputations(uint256 x) public returns (uint256) {
    //     uint256 sum = 0;
    //     for (uint256 i = 0; i <= x; i++) {
    //         sum = sum + a * b;
    //     }
    // }
}
