// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract storageSpace {
    uint256[3] arr = [1, 2, 3];

    // uint256 counter;

    function check() external view returns (uint) {
        // for (uint256 i; i < arr.length; i++) {
        //     // state reads
        //     counter++; // state reads and writes
        // }

        return arr.length;
    }
}
