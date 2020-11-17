require './lib/pieces/pawn.rb'

describe Pawn do
  white_pawn = Pawn.new(:white, [0, 1])
  black_pawn = Pawn.new(:black, [0, 6])
  describe "#initialize" do

    it "should create a pawn piece with the color white" do
      expect(white_pawn.color).to eq(:white)
    end

    it "should create a pawn piece with the color black" do
      expect(black_pawn.color).to eq(:black)
    end

    it "should assign ♟ as the white pawn's symbol" do
      expect(white_pawn.symbol).to eq('♟')
    end

    it "should assign ♙ as the black pawn's symbol" do
      expect(black_pawn.symbol).to eq('♙')
    end
  end

  describe "#get_moves" do
    board = Board.new
    it "should return an array" do
      expect(white_pawn.get_moves(board)).to be_a(Array)
    end

    it "should return 2 possible moves on first move with clear path and no captures" do
      expect(white_pawn.get_moves(board).size).to eq(2)
    end

    it "should return only one possible move when not on first move with clear path and no captures" do
      white_pawn.first_move = false
      expect(white_pawn.get_moves(board).size).to eq(1)
    end

    it "should return no moves when enemy is right in front with no capture possibilites" do
      pawn = board.board[3][1]
      board.board[3][2] = Pawn.new(:black, [3, 2])
      expect(pawn.get_moves(board).size).to eq(0)
    end

    it "should return capture moves even when a piece is in front of it" do
      pawn = board.board[3][1]
      board.board[3][2] = Pawn.new(:black, [3, 2])
      board.board[2][2] = Pawn.new(:black, [2, 2])
      board.board[4][2] = Pawn.new(:black, [4, 2])
      expect(pawn.get_moves(board).size).to eq(2)
    end
  end
end