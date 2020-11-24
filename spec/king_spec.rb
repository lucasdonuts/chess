require './lib/pieces/king.rb'

describe King do
  describe "#initialize" do
    white_king = King.new(:white, [4, 0])
    black_king = King.new(:black, [4, 7])

    it "should create a king piece with the color white" do
      expect(white_king.color).to eq(:white)
    end

    it "should create a king piece with the color black" do
      expect(black_king.color).to eq(:black)
    end

    it "should assign ♚ as the white king's symbol" do
      expect(white_king.symbol).to eq('♚')
    end

    it "should assign ♔ as the black king's symbol" do
      expect(black_king.symbol).to eq('♔')
    end
  end

  describe "#get_moves" do
    board = Board.new
    board.board[5][3] = King.new(:white, [5, 3])
    board.board[2][4] = King.new(:black, [2, 4])
    white_king = board.board[5][3]
    black_king = board.board[2][4]

    it "should return a move for every direction" do
      expect(white_king.get_moves(board)).to include([6, 4],
                                                     [6, 3],
                                                     [6, 2],
                                                     [5, 4],
                                                     [5, 2],
                                                     [4, 4],
                                                     [4, 3],
                                                     [4, 2])
    end

    it "should return no moves when surrounded by friendly pieces" do
      expect(board.board[4][0].get_moves(board)).to eq([])
    end

    it "should include enemy locations" do
      board.board[5][4] = King.new(:black, [5, 4])
      expect(white_king.get_moves(board)).to include([5, 4])
    end

    it "should not include locations that are out of bounds" do
      actual = white_king.get_moves(board).any? { |move| move.any? {|i| i < 0 || i > 7 } }
      expect(actual).to be false
    end
  end
end