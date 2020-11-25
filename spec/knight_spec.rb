require './lib/pieces/knight.rb'

describe Knight do
  board = Board.new
  white_knight = board.board[1][0]
  black_knight = board.board[1][7]

  describe "#initialize" do
    it "should create a knight piece with the color white" do
      expect(white_knight.color).to eq(:white)
    end

    it "should create a knight piece with the color black" do
      expect(black_knight.color).to eq(:black)
    end

    it "should assign ♞ as the white knight's symbol" do
      expect(white_knight.symbol).to eq('♞')
    end

    it "should assign ♘ as the black knight's symbol" do
      expect(black_knight.symbol).to eq('♘')
    end
  end

  describe "#get_moves" do
    it "should return an array" do
      expect(white_knight.get_moves).to be_a(Array)
    end

    it "should remove squares in which a friendly piece is placed" do
      expect(white_knight.get_moves.size).to eq(2)
    end

    it "should include squares in which an enemy is placed" do
      board.board[2][2] = black_knight
      expect(white_knight.get_moves).to include([2, 2])
    end
  end
end