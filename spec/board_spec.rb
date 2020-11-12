require './lib/board.rb'

describe Board do
  board = Board.new
  context "starting state of board" do
    describe "#initialize"
      it "should create an array" do
        expect(board.board).to be_a(Array)
      end
  end

  context "validating moves" do
    describe "#in_bounds?" do
      it "should return false when x coordinate is out of bounds" do
        expect(board.in_bounds?([9, 1])).to be false
      end

      it "should return false when y coordinate is out of bounds" do
        expect(board.in_bounds?([1, 9])).to be false
      end

      it "should return true when both x and y are in bounds" do
        expect(board.in_bounds?([2, 2])).to be true
      end
    end

    describe "#square_empty?" do
      board.board[0][0] = 'X'
      it "should return true when there is no piece at destination" do
        expect(board.square_empty?([3, 3])).to be true
      end

      it "should return false when destination is occupied" do
        expect(board.square_empty?([0, 0])).to be false
      end
    end
  end
end