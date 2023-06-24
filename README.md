# Optimizing a Smart Contract

### Smart Contract POV

- Readable
- Use libraries and interfaces
- OOPs concept
- Stay updated

## Ethereum Gas

### Transaction fee Calculation

    Transaction Fee = (Gas Consumed * Gas Price) * (Ether Price/10^9)

Note: Gas Price is in gwei thats why we are also converting ether price into gwei

## Ethereum Block Limit

In Bitcoin, 1 block is 1 MB, in ethereum, 1 block is 30 million gas

- Reason - To Prevent Heavy Transaction from running
- Total number of transactions per block(t/b) = 30 million / 21000 = 1428

Note: 21000 is the minimum gas for every transaction and can change depending on what the computation is. Therefore;

- transactions per block (t/b) = 30 million / Denominator
- The `Denominator` decides the number on transactions

Note - 30 million is not static. It can change. Increasing it will cause congestion in the network as much more time will be needed before transferring data to next node.

## Factors Affecting Gas Consumption

These factors affect gas consumption

- Opcode
- The type of transaction
- Memory
- State change

Transaction vs execution costs

- Execution cost - All costs related to the internal storage and manipulation of the contract.
- Transaction cost
  1. Execution cost
  2. The cost of sending data to the blockchain

## Opcode

An opcode is the portion of a machine language instruction that specifies the `operation` to be performed. Eg; ADD, MUL, STOP, DIV etc.

[Opcode list](https://ethereum.org/en/developers/docs/evm/opcodes/)

[Yellow Paper (Page 30)](https://ethereum.github.io/yellowpaper/paper.pdf)

When you compile your contract, you get the `ABI` and the `Bytecode`. The bytecode contains the opcodes.

## Slot Location

Variables are stored in a single memory, in slots in ethereum blockchain. The first variable is stored in slot [0], second variable in [1] and so on.

`Gas consumption` is equal to;

    21000 (default gas for every transaction) + Opcode Execution + cost of renting on blockchain + type of transaction

`Tip`: - To minimize costs, only declare necessary state variables.

## Payable vs non-payable gas consumption

Which will cost more gas?

### Payable

```solidity
function pay()  external payable {} // Less gas
```

### Non-payable

```solidity
function pay()  external {} // More gas
```

The difference lies in the opcodes of the 2 functions. The non-payable function has more instructions than the payable function.

The non-payable function cannot receive ether. So when you send ether to it, it reverts and has to send the ether back to the sender.

Due to this functionality, the non-payable function costs more gas.

## Unchecked vs Checked

From sol version `0.7.0` solidity checks for overflows.

### Checked

```solidity
// This function reverts
 function check() public pure returns (uint) {
        uint8 a = 255; // 0 - 255
        a + 1;
        return a;
    }
```

### Unchecked

```solidity
// In this function, the value of a will change from 255 to 0

 function check() public pure returns (uint) {
        uint8 a = 255; // 0 - 255
       unchecked {
         a + 1;
       }
        return a;
    }
```

Normally checking for overflow is a good security feature. But there are cases you'll want to used the unchecked expression.

There is a huge gas difference between the two. The unchecked expression is cheaper on gas.

Unchecked produces smaller bytecode compared to regular arithmetic operations, as it doesn't contain the underflow/overflow validation.

So if you want to have a custom error message in case overflow would occur, this code costs less gas to run

```solidity
uint256 senderBalance = _balances[sender];
require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
unchecked {

    // no validation here as it's already validated in the `require()` condition
    _balances[sender] = senderBalance - amount;
}
```

compared to this one

```solidity
uint256 senderBalance = _balances[sender];
require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");

// redundant validation here
_balances[sender] = senderBalance - amount;
```

## Minimum gas consuption (21000)

#### [Ethereum yellow paper (page 8 - Transaction Execution)](https://ethereum.github.io/yellowpaper/paper.pdf)

The execution of a transaction is the most complex part
of the Ethereum protocol: it defines the state transition
function Υ. It is assumed that any transactions executed
first pass the initial tests of intrinsic validity. These include:

1. The transaction is well-formed RLP, with no additional trailing bytes;
2. the transaction signature is valid;
3. the transaction nonce is valid (equivalent to the
   sender account’s current nonce);
4. the sender account has no contract code deployed
   (see EIP-3607 by Feist et al. [2021]);
5. the gas limit is no smaller than the intrinsic gas,
   g0, used by the transaction; and
6. the sender account balance contains at least the
   cost, v0, required in up-front payment.

Formally, we consider the function Υ, with T being a
transaction and σ the state:

## Solidity Optimizer

- Reduces Deployment Size of the contract (Deployment cost)
- Reduces function call expenses (code execution cost)

The goal of optimization is to reduce the overall number of operations needed to run a smart contract, and optimized smart contracts not only reduce the gas needed to process transactions, they are also a protection against malicious misuse.

[Read More](https://docs.soliditylang.org/en/v0.8.17/internals/optimizer.html)

[Top 10 Solidity Gas Optimization Techniques](https://www.alchemy.com/overviews/solidity-gas-optimization)

## Require Statement

Compare the two functions below;

#### With 'Require' as first statement

```solidity
    uint a;
    function check() public {
        // uses 21199 gas
        require(false);
        a = a + 1;
    }
```

#### With 'Require' as last statement

```solidity
    uint a;
    function check() public {
        // uses 43507 gas
        a = a + 1;
        require(false);
    }
```

The first code consumes less gas since it reverts and never goes to the second line. So it is never using the state variable.

In the second code, we start by running `a = a +1;` which is changing the state of our state variable `"a"`. Then after that finishes, only then are we reverting the function.

So using the require statement first, saves you gas!

## Memory Explosion

#### [Ethereum yellow paper (page 28 - Gas Cost)](https://ethereum.github.io/yellowpaper/paper.pdf)

Memory explosion is the exponential rise in gas cost with the amount of storage being used.
Make sure your array is of a size you actually require.

Example

```solidity
// SPDX-License-Identifier: MIT pragma solidity >=0.5.0 <0.9.0;

contract Memory {

function call() external pure {
    // arr[10] -- 21353 -21000 = 353
    // arr[20] -- 414 gas
    // arr[30] -- 475 gas
    uint[10000] memory arr; // 10000 -- 276761 gas (A LOT OF GAS)
    }
}
```

## Memory Cleaning

Unlike other programming languages, solidity doesn't have memory cleaning.

Example

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract memoryClean {
    // function memCheck() external pure { // 276,761 GAS
    // uint[10000] memory arr;
    //}

    function call() external pure {
        // 279,781 GAS
        for (uint i = 0; i < 10; i++) {
            memoryAllocate();
        }
    }

    function memoryAllocate() public pure {
        uint[1000] memory arr; //8261 GAS
    }
}
```

Since solidity doesn't have memory cleaning, in the `call()` function, solidity will keep allocating memory to that arrays all the times the `for loop` will be executing.

Therefore you might expect the gas for the whole `call()` operation to be `8261 * 10 GAS` since we are only calling `memoryAllocate()` 10 times but that will not be the case.

The gas for the `call()` will explode once we reach 10,000 elements and will be `279,781 GAS` as indicated in the comment. NOTE: The gas is slightly higher that for `memCheck()` because of the extra commutations but they are close.

## Function Names

Function names play a crucial role in your gas consumption. If your function names are not appropriate then you'll be paying a hug amount of gas.

Example

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract functionName {
    function three() external pure returns (uint) {
        // 21210 gas
        return 1;
    }

    function two() external pure returns (uint) {
        // 21210,21232
        return 1;
    }

    function one() external pure returns (uint) {
        //21210,21232,21254
        return 1;
    }
}
```

In the above code, the only thing we have different are the function names.

When we call `one()` when it's the only function, the gas is `21210`. When we add `two()`, then call `one()` the gas changes to `21232`. Same thing happens when we add another function `three()`. Gas for calling `one()` increases again to `21254`. The gas for function `two()` also increase when we add another function.

So what is happening;-

Solidity converts the function names into `Hexadecimal numbers` for the machine to understand. The smallest hexadecimal number, is the first function for the machine programming language. And since the functions are executed in a linear fashion, to run our `one()` function, solidity has to check all the other functions that precede it to determine if it's the one or not. This checking is work and hence requires gas.

That's why the gas increases the further down the function is.

If you are creating a function that will consume a lot of gas, try to name the function in such a way that the hexadecimal number is at the top of the assembly code. ie. when converted, it's the smallest hexadecimal number.

## Shift Operator

Bit Shifting;-
A bit shift moves each digit in a number's binary representation left or right.

In the example below, we will see the importance of using the right operator at the right time.

Example

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract shiftOperator {
    function multiplybyTwo(uint x) public pure returns (uint) {
        //21994 gas
        return x * 2;

        // 21793 gas (LESS)
        return x << 1;
    }

    function divisionbyTwo(uint x) public pure returns (uint) {
        // 21987 gas
        return x / 2;

        // 21815 gas (LESS)
        return x >> 1;
    }
}
```

So, as we see from the example, there are multiple ways of doing an operation. So whenever you are trying to do an operation, it's better to look at the [opcode table](https://ethereum.org/en/developers/docs/evm/opcodes/) to see which are consuming less amount of gas.

### Left Shifts

When shifting left, the most-significant bit is lost, and a `0` bit is inserted on the other end.

The left shift operator is usually written as `<<`.

```
0010 << 1 → 0100
0010 << 2 → 1000
```

A single left shift multiplies a binary number by 2:

```
0010 << 1 → 0100

0010 is 2
0100 is 4
```

The left shift `(<<)` operator is used for the multiplication.

### Right Shifts

### Logical Right Shifts / Zero fill right shift `(>>>)`

When shifting right with a logical right shift, the least-significant bit is lost and a `0` is inserted on the other end. It shifts right by pushing zeros in from the left, and let the rightmost bits fall off.

```
1011 >>> 1  →  0101
1011 >>> 3  →  0001
```

For positive numbers, a single logical right shift divides a number by 2, throwing out any remainders.

```
0101 >>> 1  →  0010

0101 is 5
0010 is 2
```

### Arithmetic Right Shifts / Signed right shift `(>>)`

When shifting right with an arithmetic right shift, the least-significant bit is lost and the most-significant bit is copied. It shifts right by pushing copies of the leftmost bit in from the left, and let the rightmost bits fall off.

Languages handle arithmetic and logical right shifting in different ways. Solidity provides two right shift operators: >> does an arithmetic right shift and >>> does a logical right shift.

```
1011 >> 1  →  1101
1011 >> 3  →  1111

0011 >> 1  →  0001
0011 >> 2  →  0000
```

The first two numbers had a `1` as the most significant bit, so more `1's` were inserted during the shift. The last two numbers had a `0` as the most significant bit, so the shift inserted more `0's`.

If a number is encoded using [two's complement](https://www.interviewcake.com/concept/python/binary-numbers?#twos-complement), then an arithmetic right shift preserves the number's sign, while a logical right shift makes the number positive.

```
// Arithmetic shift
1011 >> 1 → 1101
1011 is -5
1101 is -3

// Logical shift
1111 >>> 1 → 0111
1111 is -1
0111 is 7
```

## Bit Shifting Overflow Issue

Shifting all of a number's bits to the left by 1 bit is equivalent to multiplying the number by 2. Thus, all of a number's bits to the left by n bits is equivalent to multiplying that number by 2n.

Notice that we fill in the spots that open up with 0s. If a bit goes further left than the place of the most-significant digit, the bit is lost. This means that left shifting a number too far will result in overflow, where the number of bits that are saved by the data type are insufficient to represent the actual number.

For example, let's assume that our computer memory is of 5bits (just for illustration purposes). Let's shift `6`, 3 times. It will be same as 6 by 2^3. The result is 48, which is 110000.

```
6 = 0,0,1,1,0

0,1,1,0,0 = 12
1,1,0,0,0 = 24
1,0,0,0,0 = 16
```

if you will notice, instead of getting `48` like we wanted, we get `16` because a `1` was dropped when our memory was full hence creating an overflow.

So before using the shift operator, make sure that your execution won't lead into an overflow.

## Storage

- Whenever you are changing a storage variable `from 0 to non-zero `then it cost you `20,000 gas`.
- Whenever you are changing a storage variable `from non-zero to non-zero `then it cost you `5,000 gas`.
- Whenever you are changing a storage variable `from non-zero to 0 `then it cost you `refund gas`.

This is because when the value of your variable is non-zero, then ethereum needs to keep track of that variable but if it was 0, them ethereum doesn't need to keep track.

N/B

:- Whenever you are accessing a storage variable `for the first time`, you have to pay an additional `2100 gas`.

:- if the variable has `already been accessed`, you pay `100 gas`.

## Integers

Taking two int variables, `uint8 a = 2;` and `uint256 a = 2;` which one do you think will consume more gas?

You might have thought it's the `uint256` but that's not the case. `uint256` consumes less gas compared to `uint8`.

Why is this so? In the Ethereum Virtual Machine (EVM), each storage slot is of 256 bits for each and every variable. So when you declare a `uint8` variable, we only use 8bit of memory from our 256 bit slot, but in the background, the remaining 248 bits get padded with zeros. And that's why we have to pay `much more gas` whenever we are declaring a `smaller size variable`.

When you use a `uint256` variable it will use the whole memory and there will be no padding of zeros. So, to save gas, whenever you are declaring a variable you should use a `256 bit` variable.

NB:- there are exceptions.

## Variable Packing

Solidity contracts have contiguous 32 byte (256 bit) slots used for storage. When we arrange variables so multiple fit in a single slot, it is called variable packing.

If a variable we are trying to pack exceeds the 32 byte limit of the current slot, it gets stored in a new one. We must figure out which variables fit together the best to minimize wasted space.

Because each storage slot costs gas, variable packing helps us optimize our gas usage by reducing the number of slots our contract requires.

Let’s look at an example:

```
uint128 a;
uint256 b;
uint128 c;
```

These variables are not packed. If `b` was packed with `a`, it would exceed the 32 byte limit so it is instead placed in a new storage slot. The same thing happens with `c` and `b`.

```
uint128 a;
uint128 c;
uint256 b;
```

These variables are packed. Because packing `c` with `a` does not exceed the 32 byte limit, they are stored in the same slot.

Keep variable packing in mind when choosing data types — a smaller version of a data type is only useful if it helps pack the variable in a storage slot. If a uint128 does not pack, we might as well use a uint256.

NOTE :- Variable packing only occurs in storage — memory and call data does not get packed. You will not save space trying to pack function arguments or local variables.

Use this code to check slots on Remix

```solidity
//SPDX-License-Identifier: Unlicense
pragma solidity >=0.5.0 <0.9.0;

contract Slot {
    uint256 b;
    uint128 a;
    uint128 c;

    function getSlotA() external pure returns (uint value) {
        assembly {
            value := a.slot
        }
    }

    function getSlotB() external pure returns (uint value) {
        assembly {
            value := b.slot
        }
    }

    function getSlotC() external pure returns (uint value) {
        assembly {
            value := c.slot
        }
    }
}
```

## Constants

If you have a variable who's value will never change, ethereum suggests that instead of using a variable, we should use a constant.

Example;

```
uint public constant v = 1;
```

is cheaper than,

```
uint public v = 1;
```

When you declare a state variable, it is being stored at state level but when you use the `constant` key word, it is being stored in the `bytecode` of our contract.

## Memory vs Calldata

### `Memory`

Memory is reserved for variables that are defined within the scope of a function. They only persist while a function is called, and thus are temporary variables that cannot be accessed outside this scope (ie anywhere else in your contract besides within that function). However, they are mutable within that function.

### `Calldata`

Calldata is an immutable, temporary location where function arguments are stored, and behaves mostly like memory.

A point to note, you should always use call data with `dynamic variables`. And all this variables should be present in the `external` function argument.

It is recommended to try to use calldata because it avoids unnecessary copies and ensures that the data is unaltered. Arrays and structs with calldata data location can also be returned from functions.

Example to help differentiate

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract demo {
    function memoryTest(
        string memory _exampleString
    ) public pure returns (string memory) {
        _exampleString = "Hello";
        string memory newString = _exampleString;
        return newString;
    }

    function calldataTest(
        string calldata _exampleString
    ) external pure returns (string memory) {
        // you cannot assign a value to _exampleString once it's declared/passed as an arg. Hence the line below will throw an error.
        // _exampleString = "Hello";

        string memory newString = _exampleString;
        return newString;


        // use calldata in external function.
        // the variables are immutable in nature.
        // should be used in the arguments of a function
    }
}
```
