// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract optimize {
    function blue() external pure returns (uint256) {
        return 1;
    }

    function white() external pure returns (uint256) {
        //heavy code should be inside this function as white hexadecimal number is the smallest
        return 1;
    }

    function green() external pure returns (uint256) {
        return 1;
    }
}
