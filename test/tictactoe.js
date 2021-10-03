const {expect} = require('chai');

describe('TicTacToe contract', () => {
	let Game, game;

	beforeEach(async () => {
		Game = await ethers.getContractFactory('TicTacToe');
		game = await Game.deploy();
		[owner, addr1, addr2] = await ethers.getSigners();
	});

	describe('Preparation of game', () => {

		it('Should fail when trying to join before game created', async () => {
			await expect(game.connect(add2).joinGame()).to.be.revertedWith('Game is not created yet.');
		});

		it('Should return correct address of game creator', async () => {
			var expectedCreator = await game.connect(addr1).createGame();
			expect(expectedCreator).to.equal(addr1);
		});

		it('Should return correct address of game joiner', async () => {
			var expectedJoiner = await game.connect(addr2).joinGame();
			expect(expectedJoiner).to.equal(addr2);
		});
		
	});

	describe('Game logic', () => {

		beforeEach(async () => {
			await game.connect(addr1).createGame();
			await game.connect(addr2).joinGame();
		});

		it('Should fail when trying to mark on already marked position', async () => {			
			await game.connect.(addr2).playerAction(5);
			await expect(game.connect.(addr1).playerAction(5)).to.be.revertedWith('Already placed...');
		});

		it('Should fail when trying to act on opponent turn', async () => {
			await game.connect(addr2).playerAction(4);
			await expect(game.connect(addr2).playerAction(7).to.be.revertedWith('Invalid turn...'));
		});

		it('Check track of player2 wins', async () => {
			await game.connect(addr2).playerAction(4);
			await game.connect(addr1).playerAction(5);
			await game.connect(addr2).playerAction(2);
			await game.connect(addr1).playerAction(6);
			await game.connect(addr2).playerAction(1);
			await game.connect(addr1).playerAction(3);
			await expect(game.connect(addr2).playerAction(7)).to.emit(game, 'winPlayer2').withArgs();
		});

		it('Check track of player1 wins', async () => {
			await game.connect(addr2).playerAction(4);
			await game.connect(addr1).playerAction(5);
			await game.connect(addr2).playerAction(2);
			await game.connect(addr1).playerAction(6);
			await game.connect(addr2).playerAction(1);
			await game.connect(addr1).playerAction(7);
			await game.connect(addr2).playerAction(3);
			await expect(game.connect(addr1).playerAction(8)).to.emit(game, 'winPlayer1').withArgs();
		});

		it('Check track of game draw', async () => {
			wait game.connect(addr2).playerAction(4);
			await game.connect(addr1).playerAction(5);
			await game.connect(addr2).playerAction(2);
			await game.connect(addr1).playerAction(6);
			await game.connect(addr2).playerAction(1);
			await game.connect(addr1).playerAction(7);
			await game.connect(addr2).playerAction(8);
			await game.connect(addr1).playerAction(0);
			await expect(game.connect(addr2).playerAction(3)).to.emit(game, 'draw').withArgs();
		});
	});
});