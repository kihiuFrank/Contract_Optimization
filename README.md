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
