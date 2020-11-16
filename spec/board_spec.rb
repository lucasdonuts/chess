require './lib/board.rb'

describe Board do
  board = Board.new
  context "starting state of board" do
    describe "#initialize" do
      it "should create an array" do
        expect(board.board).to be_a(Array)
      end
    end

    describe "#place_starting_pieces" do
      it "should place white pawns in correct starting positions" do
        board.place_starting_pieces
        expect(board.board[0][1]).to be_an_instance_of(Pawn)
        expect(board.board[1][1]).to be_an_instance_of(Pawn)
        expect(board.board[2][1]).to be_an_instance_of(Pawn)
        expect(board.board[3][1]).to be_an_instance_of(Pawn)
        expect(board.board[4][1]).to be_an_instance_of(Pawn)
        expect(board.board[5][1]).to be_an_instance_of(Pawn)
        expect(board.board[6][1]).to be_an_instance_of(Pawn)
        expect(board.board[7][1]).to be_an_instance_of(Pawn)
      end

      it "should place white rooks in correct starting positions" do
        board.place_starting_pieces
        expect(board.board[0][0]).to be_an_instance_of(Rook)
        expect(board.board[7][0]).to be_an_instance_of(Rook)
      end

      it "should place white knights in correct starting positions" do
        board.place_starting_pieces
        expect(board.board[1][0]).to be_an_instance_of(Knight)
        expect(board.board[6][0]).to be_an_instance_of(Knight)
      end

      it "should place white bishops in correct starting positions" do
        board.place_starting_pieces
        expect(board.board[2][0]).to be_an_instance_of(Bishop)
        expect(board.board[5][0]).to be_an_instance_of(Bishop)
      end

      it "should place white queen in correct starting position" do
        board.place_starting_pieces
        expect(board.board[3][0]).to be_an_instance_of(Queen)
      end

      it "should place white king in correct starting position" do
        board.place_starting_pieces
        expect(board.board[4][0]).to be_an_instance_of(King)
      end

      it "should place black pawns in correct starting positions" do
        board.place_starting_pieces
        expect(board.board[0][6]).to be_an_instance_of(Pawn)
        expect(board.board[1][6]).to be_an_instance_of(Pawn)
        expect(board.board[2][6]).to be_an_instance_of(Pawn)
        expect(board.board[3][6]).to be_an_instance_of(Pawn)
        expect(board.board[4][6]).to be_an_instance_of(Pawn)
        expect(board.board[5][6]).to be_an_instance_of(Pawn)
        expect(board.board[6][6]).to be_an_instance_of(Pawn)
        expect(board.board[7][6]).to be_an_instance_of(Pawn)
      end

      it "should place black rooks in correct starting positions" do
        board.place_starting_pieces
        expect(board.board[0][0]).to be_an_instance_of(Rook)
        expect(board.board[7][0]).to be_an_instance_of(Rook)
      end

      it "should place black knights in correct starting positions" do
        board.place_starting_pieces
        expect(board.board[1][0]).to be_an_instance_of(Knight)
        expect(board.board[6][0]).to be_an_instance_of(Knight)
      end

      it "should place black bishops in correct starting positions" do
        board.place_starting_pieces
        expect(board.board[2][0]).to be_an_instance_of(Bishop)
        expect(board.board[5][0]).to be_an_instance_of(Bishop)
      end

      it "should place black queen in correct starting position" do
        board.place_starting_pieces
        expect(board.board[3][0]).to be_an_instance_of(Queen)
      end

      it "should place black king in correct starting position" do
        board.place_starting_pieces
        expect(board.board[4][0]).to be_an_instance_of(King)
      end
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