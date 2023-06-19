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

### Slot Location

Variables are stored in a single memory, in slots in ethereum blockchain. The first variable is stored in slot [0], second variable in [1] and so on.

`Gas consumption` is equal to;

    21000 (default gas for every transaction) + Opcode Execution + cost of renting on blockchain + type of transaction

`Tip`: - To minimize costs, only declare necessary state variables.

### Payable vs non-payable gas consumption

Which will cost more gas?

#### Payable

```solidity
function pay()  external payable {} // Less gas
```

#### Non-payable

```solidity
function pay()  external {} // More gas
```

The difference lies in the opcodes of the 2 functions. The non-payable function has more instructions than the payable function.

The non-payable function cannot receive ether. So when you send ether to it, it reverts and has to send the ether back to the sender.

Due to this functionality, the non-payable function costs more gas.

### Unchecked vs Checked

From sol version `0.7.0` solidity checks for overflows.

#### Checked

```solidity
// This function reverts
 function check() public pure returns (uint) {
        uint8 a = 255; // 0 - 255
        a + 1;
        return a;
    }
```

#### Unchecked

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

### Minimum gas consuption (21000)

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

### Solidity Optimizer

- Reduces Deployment Size of the contract (Deployment cost)
- Reduces function call expenses (code execution cost)

The goal of optimization is to reduce the overall number of operations needed to run a smart contract, and optimized smart contracts not only reduce the gas needed to process transactions, they are also a protection against malicious misuse.

[Read More](https://docs.soliditylang.org/en/v0.8.17/internals/optimizer.html)

[Top 10 Solidity Gas Optimization Techniques](https://www.alchemy.com/overviews/solidity-gas-optimization)

### Require Statement

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

### Memory Explosion

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

### Memory Cleaning

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

### Function Names

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
