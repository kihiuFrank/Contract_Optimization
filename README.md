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
