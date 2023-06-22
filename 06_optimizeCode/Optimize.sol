// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract storageSpace {
    uint256[3] arr = [1, 2, 3];
    uint256 counter;

    function sol() external {
        uint256 length = arr.length; // one state read
        uint256 local_mycounter = counter; // one state read

        for (uint256 i; i < length; i++) {
            // local reads
            local_mycounter++; // local reads and writes
        }
        counter = local_mycounter; // one state write

        // this way we won't read and write state arr.length times.
    }
}
