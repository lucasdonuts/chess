require './lib/pieces/bishop.rb'
require './lib/board.rb'

describe Bishop do
  describe "#initialize" do
    white_bishop = Bishop.new(:white, [2, 0])
    black_bishop = Bishop.new(:black, [2, 7])

    it "should create a bishop piece with the color white" do
      expect(white_bishop.color).to eq(:white)
    end

    it "should create a bishop piece with the color black" do
      expect(black_bishop.color).to eq(:black)
    end

    it "should assign ♝ as a white bishop's symbol" do
      expect(white_bishop.symbol).to eq('♝')
    end

    it "should assign ♗ as the the black bishop's symbol" do
      expect(black_bishop.symbol).to eq('♗')
    end
  end

  describe "#up_moves" do
    board = Board.new
    board.board[5][3] = Bishop.new(:white, [5, 3])
    white_bishop = board.board[5][3]
    puts "Remember to remove board dependencies if possible"

    it "should return no moves when blocked in by friendly pieces" do
      expect(board.board[2][0].up_moves(board)).to eq([])
    end

    it "should include both left and right diagonal moves" do
      expect(white_bishop.up_moves(board)).to include([4, 4], [6, 4])
    end

    it "should continue adding to one path even after another has ended" do
      expect(white_bishop.up_moves(board)).to include([2, 6])
    end

    it "should include enemy locations on it's path" do
      expect(white_bishop.up_moves(board)).to include([2, 6])
    end

    it "should stop adding moves when reaching a non-empty square" do
      expect(white_bishop.up_moves(board)).not_to include([1, 7])
    end

    it "should not return moves that are out of bounds" do
      actual = white_bishop.up_moves(board).any? { |move| move.any? {|i| i < 0 || i > 7 } }
      expect(actual).to be false
    end
  end

  describe "#down_moves" do
    board = Board.new
    board.board[2][4] = Bishop.new(:black, [2, 4])
    black_bishop = board.board[2][4]
    puts "Remember to remove board dependencies if possible"

    it "should return no moves when blocked in by friendly pieces" do
      expect(board.board[2][7].down_moves(board)).to eq([])
    end

    it "should include both left and right diagonal moves" do
      expect(black_bishop.down_moves(board)).to include([1, 3], [3, 3])
    end

    it "should continue adding to one path even after another has ended" do
      expect(black_bishop.down_moves(board)).to include([5, 1])
    end

    it "should include enemy locations on it's path" do
      expect(black_bishop.down_moves(board)).to include([5, 1])
    end

    it "should stop adding moves when reaching a non-empty square" do
      expect(black_bishop.down_moves(board)).not_to include([6, 0])
    end

    it "should not return moves that are out of bounds" do
      actual = black_bishop.down_moves(board).any? { |move| move.any? {|i| i < 0 || i > 7 } }
      expect(actual).to be false
    end
  end
end