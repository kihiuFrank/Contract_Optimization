//SPDX-License-Identifier: Unlicense
pragma solidity >=0.5.0 <0.9.0;

contract Slot {
    uint256 private num2 = 20;
    uint256 private num1 = 10;

    // finds the slot location of a variable
    function findSlotLocation() public pure returns (uint) {
        uint location;
        assembly {
            location := num2.slot
            location := num1.slot
        }
        return location;
    }

    // finds the value in a slot
    function findValue(uint slot) public view returns (uint) {
        uint value;
        assembly {
            value := sload(slot)
        }
        return value;
    }
}
