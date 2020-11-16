require './lib/board.rb'
# currently writing and testing path_obstructed? method, currently only checks destination

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
        expect(board.board[0][0]).to be_an_instance_of(Rook)
        expect(board.board[7][0]).to be_an_instance_of(Rook)
      end

      it "should place white knights in correct starting positions" do
        expect(board.board[1][0]).to be_an_instance_of(Knight)
        expect(board.board[6][0]).to be_an_instance_of(Knight)
      end

      it "should place white bishops in correct starting positions" do
        expect(board.board[2][0]).to be_an_instance_of(Bishop)
        expect(board.board[5][0]).to be_an_instance_of(Bishop)
      end

      it "should place white queen in correct starting position" do
        expect(board.board[3][0]).to be_an_instance_of(Queen)
      end

      it "should place white king in correct starting position" do
        expect(board.board[4][0]).to be_an_instance_of(King)
      end

      it "should place black pawns in correct starting positions" do
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
        expect(board.board[0][0]).to be_an_instance_of(Rook)
        expect(board.board[7][0]).to be_an_instance_of(Rook)
      end

      it "should place black knights in correct starting positions" do
        expect(board.board[1][0]).to be_an_instance_of(Knight)
        expect(board.board[6][0]).to be_an_instance_of(Knight)
      end

      it "should place black bishops in correct starting positions" do
        expect(board.board[2][0]).to be_an_instance_of(Bishop)
        expect(board.board[5][0]).to be_an_instance_of(Bishop)
      end

      it "should place black queen in correct starting position" do
        expect(board.board[3][0]).to be_an_instance_of(Queen)
      end

      it "should place black king in correct starting position" do
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
      it "should return true when there is no piece at destination" do
        expect(board.square_empty?([3, 3])).to be true
      end

      it "should return false when destination is occupied" do
        expect(board.square_empty?([0, 0])).to be false
      end
    end

    describe "#current_players_piece?" do
      it "should return true when player 1 selects a white piece" do
        player1 = Player.new('Player 1', :white)
        piece = board.board[0][1]
        expect(board.current_players_piece?(piece, player1)).to eq true
      end

      it "should return false when player 2 selects a white piece" do
        player2 = Player.new('Player 2', :black)
        piece = board.board[0][1]
        expect(board.current_players_piece?(piece, player2)).to eq false
      end

      it "should return true when player 2 selects a black piece" do
        player2 = Player.new('Player 2', :black)
        piece = board.board[0][6]
        expect(board.current_players_piece?(piece, player2)).to eq true
      end

      it "should return false when player 1 selects a black piece" do
        player1 = Player.new('Player 1', :white)
        piece = board.board[0][6]
        expect(board.current_players_piece?(piece, player1)).to eq false
      end
    end

    describe "#get_white_positions" do
      white_positions = board.get_white_positions

      it "should return an array" do
        expect(white_positions).to be_a(Array)
      end

      it "should only contain squares occupied by white pieces" do
        expect(board.board[white_positions[0][0]][white_positions[0][1]].color).to be(:white)
        expect(board.board[white_positions[7][0]][white_positions[7][1]].color).to be(:white)
        expect(board.board[white_positions.last[0]][white_positions.last[1]].color).to be(:white)
      end
    end

    describe "#get_black_positions" do
      black_positions = board.get_black_positions

      it "should return an array" do
        expect(black_positions).to be_a(Array)
      end

      it "should only contain squares occupied by black pieces" do
        expect(board.board[black_positions[0][0]][black_positions[0][1]].color).to be(:black)
        expect(board.board[black_positions[7][0]][black_positions[7][1]].color).to be(:black)
        expect(board.board[black_positions.last[0]][black_positions.last[1]].color).to be(:black)
      end
    end

    describe "#path_obstructed?" do
      context "checking knight paths" do
        board = Board.new
        knight = board.board[1][0]
        it "should return true when destination occupied by friendly piece" do
          expect(board.path_obstructed?(knight, [3, 1])).to eq true
        end

        it "should return false when destination is unoccupied" do
          expect(board.path_obstructed?(knight, [3, 2])).to eq false
        end

        it "should return false when destination is occupied by enemy piece" do
          board.board[2][2] = Pawn.new(:black, [2, 2])
          expect(board.path_obstructed?(knight, [2, 2])).to eq false
        end
      end

      context "checking pawn paths" do
        board = Board.new
        pawn = board.board[3][1]

        it "should return false when destination is unoccupied" do
          expect(board.path_obstructed?(pawn, [3, 2])).to eq false
        end

        it "should return true when destination occupied by friendly piece" do
          board.board[3][2] = Knight.new(:white, [3, 2])
          expect(board.path_obstructed?(pawn, [3, 2])).to eq true
        end

        it "should return false when destination is occupied by enemy piece" do
          board.board[3][2] = Pawn.new(:black, [3, 2])
          expect(board.path_obstructed?(pawn, [3, 2])).to eq false
        end
      end

      context "check queen paths" do
        board = Board.new
        queen = board.board[3][0]

        it "should return false when destination is unoccupied" do
          board.board[3][1] = nil
          expect(board.path_obstructed?(queen, [3, 1])).to eq false
        end

        it "should return true when destination occupied by friendly piece" do
          board.board[3][2] = Knight.new(:white, [3, 2])
          expect(board.path_obstructed?(queen, [3, 2])).to eq true
        end

        it "should return false when destination is occupied by enemy piece" do
          board.board[3][2] = Pawn.new(:black, [3, 2])
          expect(board.path_obstructed?(queen, [3, 2])).to eq false
        end
      end
    end
  end
end