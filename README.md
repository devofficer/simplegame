# simplegame

Solidity code for TicTacToe game.
Whenever players mark on the board, it will require a function call to the contract.
The contract will check whether game ends with one player winning or both players draw match.
And it will emit events according to the game result.

# Hardhat test

## Install packages for hardhat

npm install

## Run test

npx hardhat test