// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// import "./IERC20.sol";

contract TicTacToe {
    
    uint[] board = new uint[](9);
    uint currentMove;
    uint betAmount;
    address payable player1;
    address payable player2;
    // IERC20 token;
    bool public isCreated = false;
    
    event gameCreated(address p1);
    event gameJoint(address p2);
    event winPlayer1();
    event winPlayer2();
    event draw();
    event didAction(uint position, uint player);
    
    uint turn = 0; // 0 indicates player1's turn while 1 indicates player2's
    
    // constructor(address tokenAddress) {
    //     token = IERC20(tokenAddress);
    // }
    
    function createGame() public payable returns (address) {
        player1 = payable(msg.sender);
        betAmount = msg.value;
        require (player1.balance >= betAmount, "Not enough token to create game.");
        // token.transferFrom(player1, address(this), betAmount);
        isCreated = true;
        emit gameCreated(player1);
        return player1;
    }
    
    function joinGame() public payable returns (address) {
        require (isCreated, "Game is not created yet.");
        player2 = payable(msg.sender);
        require (player2.balance >= betAmount, "Not enough token to join game.");
        // token.transferFrom(player2, address(this), betAmount);
        emit gameJoint(player2);
        return player2;
    }
    
    function endGame(uint _winner) private {
        if (_winner == 1) {
            player1.transfer(2 * betAmount);
            emit winPlayer1();
        }
        if (_winner == 2) {
            player2.transfer(2 * betAmount);
            emit winPlayer2();
        }
        if (_winner == 0) {
            player1.transfer(betAmount);
            player2.transfer(betAmount);
            emit draw();
        }
        currentMove = 0;
        betAmount = 0;
        isCreated = false;
        for (uint i = 0; i < 9; i++)
            board[i] = 0;
    }
    
    function playerAction(uint position) external {
        require (validTurn(), "Invalid turn...");
        require (position >= 0 && position < 9, "Invalid position...");
        require (board[position] == 0, "Already placed...");
        
        currentMove++;
        board[position] = turn + 1;
        emit didAction(position, turn);
        turn = 1 - turn;
        
        uint winner = checkWinner();
        
        if (winner == 1)
            endGame(1);
        
        if (winner == 2)
            endGame(2);
        
        if (winner == 0 && currentMove == 9)
            endGame(0);
         
    }
    
    function validTurn() private view returns (bool) {
        if (turn == 0 && msg.sender != player1)
            return false;
        if (turn == 1 && msg.sender != player2)
            return false;
        return true;
    }
    
    uint[][] tests = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // row match
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // column match
        [0, 4, 8], [2, 4, 6] // diagnose match
    ];
    
    function checkWinner() private view returns (uint) {
        // checks if there is a match by row, column or diagnose
        // return 1 when player1's match, 2 when player2's match, 0 when no match
        for(uint i = 0; i < 8; i++) {
            uint[] memory crosses = tests[i];
            if (
                board[crosses[0]] != 0 &&
                board[crosses[0]] == board[crosses[1]] &&
                board[crosses[0]] == board[crosses[2]]
            ) return board[crosses[0]];
        }
        return 0;
    }

}