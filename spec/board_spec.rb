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

  describe "#get_enemy_list" do
    it "should only return black pieces when checking for white" do
      black_pieces = board.get_enemy_list(:white)
      actual = black_pieces.all?{|piece| piece.color == :black}
      expect(actual).to be true
    end

    it "should only return white pieces when checking for black" do
      white_pieces = board.get_enemy_list(:black)
      actual = white_pieces.all?{|piece| piece.color == :white}
      expect(actual).to be true
    end
  end

  describe "#promotion" do
    it "should return true when a white pawn has reached the top row" do
      board = Board.new
      board.board[0][7] = Pawn.new(:white, [0, 7], board)
      expect(board.promotion?(board.board[0][7])).to be true
    end

    it "should return true when a black pawn has reached the bottom row" do
      board = Board.new
      board.board[0][0] = Pawn.new(:black, [0, 0], board)
      expect(board.promotion?(board.board[0][0])).to be true
    end

    it "should return false when white pawn is not in top row" do
      board = Board.new
      expect(board.promotion?(board.board[0][1])).to be false
    end

    it "should return false when there are no black pawns on bottom row" do
      board = Board.new
      expect(board.promotion?(board.board[0][6])).to be false
    end
  end

  context "validating moves" do
    describe "#valid_selection?" do # Maybe redundant after check_square function
      it "should return true when player selects their own piece" do
        expect(board.valid_selection?([1, 0], :white)).to be true
      end

      it "should return false when player selects an empty square" do
        expect(board.valid_selection?([0, 2], :white)).to be false
      end

      it "should return false when white selects a black piece" do
        expect(board.valid_selection?([0, 6], :white)).to be false
      end

      it "should return false when black selects a white piece" do
        expect(board.valid_selection?([0, 2], :black)).to be false
      end

      it "should return false when selecting a piece with no legal moves" do
        skip
        board.board[7][3] = Bishop.new(:black, [7, 3])
        expect(board.valid_selection?([5, 1], :white)).to be false
      end
    end

    describe "#valid_destination?" do
      it "should return false when move puts player's king in check" do
        skip
        board = Board.new
        board.board[7][3] = Bishop.new(:black, [7, 3])
        expect(board.valid_destination?(board.board[5][1], [5, 2])).to be false
      end

      it "should return true when destination is included in piece's move list" do
        expect(board.valid_destination?(board.board[1][0], [2, 2])).to be true
      end

      it "should return false when destination is not in move list" do
        expect(board.valid_destination?(board.board[1][0], [6, 5])).to be false
      end
    end

    describe "#check_square" do
      it "should return 'enemy' when square contains enemy piece" do
        expect(board.check_square([0, 6], :white)).to eq 'enemy'
      end

      it "should return 'friendly' when square contains friendly piece" do
        expect(board.check_square([0, 1], :white)).to eq 'friendly'
      end

      it "should return 'empty' when square is empty" do
        expect(board.check_square([0, 2], :white)).to eq 'empty'
      end
    end

    describe "#can_castle_left?" do
      context "white side" do
        it "should return false when any squares between are occupied" do
          skip
          board = Board.new
          white_king = board.board[4][0]
          expect(board.can_castle_left?(white_king)).to be false
        end

        it "should return true when squares between corresponding rook and king are empty and neither have moved" do
          skip
          board = Board.new
          white_king = board.board[4][0]
          board.board[3][0] = nil
          board.board[2][0] = nil
          board.board[1][0] = nil
          expect(board.can_castle_left?(white_king)).to be true
        end

        it "should return false when any squares passed over by the king are under attack" do
          skip
          board = Board.new
          white_king = board.board[4][0]
          board.board[3][0] = nil
          board.board[2][0] = nil
          board.board[1][0] = nil
          board.board[3][1] = Rook.new(:black, [3, 1], board)
          expect(board.can_castle_left?(white_king)).to be false
          board.board[2][1] = Rook.new(:black, [2, 1], board)
          board.board[3][1] = nil
          expect(board.can_castle_left?(white_king)).to be false
        end

        it "should return false when king has moved" do
          skip
          board = Board.new
          board.board[3][0] = nil
          board.board[2][0] = nil
          board.board[1][0] = nil
          white_king = board.board[4][0]
          white_king.first_move = false
          expect(board.can_castle_left?(white_king)).to be false
        end

        it "should return false when rook has moved" do
          skip
          board = Board.new
          board.board[3][0] = nil
          board.board[2][0] = nil
          board.board[1][0] = nil
          white_king = board.board[4][0]
          board.left_white_rook.first_move = false
          expect(board.can_castle_left?(white_king)).to be false
        end
      end

      context "black side" do
        it "should return false when any squares between are occupied" do
          skip
          board = Board.new
          black_king = board.board[4][7]
          expect(board.can_castle_left?(black_king)).to be false
        end

        it "should return true when squares between corresponding rook and king are empty and neither have moved" do
          skip
          board = Board.new
          black_king = board.board[4][7]
          board.board[3][7] = nil
          board.board[2][7] = nil
          board.board[1][7] = nil
          expect(board.can_castle_left?(black_king)).to be true
        end

        it "should return false when any squares passed over by the king are under attack" do
          skip
          board = Board.new
          black_king = board.board[4][7]
          board.board[3][7] = nil
          board.board[2][7] = nil
          board.board[1][7] = nil
          board.board[3][6] = Rook.new(:white, [3, 6], board)
          expect(board.can_castle_left?(black_king)).to be false
          board.board[2][6] = Rook.new(:white, [2, 6], board)
          board.board[3][1] = nil
          expect(board.can_castle_left?(black_king)).to be false
        end

        it "should return false when king has moved" do
          skip
          board = Board.new
          board.board[3][7] = nil
          board.board[2][7] = nil
          board.board[1][7] = nil
          black_king = board.board[4][7]
          black_king.first_move = false
          expect(board.can_castle_left?(black_king)).to be false
        end

        it "should return false when rook has moved" do
          skip
          board = Board.new
          board.board[3][7] = nil
          board.board[2][7] = nil
          board.board[1][7] = nil
          black_king = board.board[4][7]
          board.left_black_rook.first_move = false
          expect(board.can_castle_left?(black_king)).to be false
        end
      end
    end

    describe "#can_castle_right?" do
      context "white side" do
        it "should return false when any squares between are occupied" do
          skip
          board = Board.new
          white_king = board.board[4][0]
          expect(board.can_castle_right?(white_king)).to be false
        end

        it "should return true when squares between corresponding rook and king are empty and neither have moved" do
          skip
          board = Board.new
          white_king = board.board[4][0]
          board.board[5][0] = nil
          board.board[6][0] = nil
          expect(board.can_castle_right?(white_king)).to be true
        end

        it "should return false when any squares passed over by the king are under attack" do
          skip
          board = Board.new
          white_king = board.board[4][0]
          board.board[5][0] = nil
          board.board[6][0] = nil
          board.board[5][1] = Rook.new(:black, [5, 1], board)
          expect(board.can_castle_right?(white_king)).to be false
          board.board[6][1] = Rook.new(:black, [6, 1], board)
          board.board[5][1] = nil
          expect(board.can_castle_right?(white_king)).to be false
        end

        it "should return false when king has moved" do
          skip
          board = Board.new
          board.board[5][0] = nil
          board.board[6][0] = nil
          white_king = board.board[4][0]
          white_king.first_move = false
          expect(board.can_castle_right?(white_king)).to be false
        end

        it "should return false when rook has moved" do
          skip
          board = Board.new
          board.board[5][0] = nil
          board.board[6][0] = nil
          white_king = board.board[4][0]
          board.right_white_rook.first_move = false
          expect(board.can_castle_right?(white_king)).to be false
        end
      end

      context "black side" do
        it "should return false when any squares between are occupied" do
          skip
          board = Board.new
          black_king = board.board[4][7]
          expect(board.can_castle_right?(black_king)).to be false
        end

        it "should return true when squares between corresponding rook and king are empty and neither have moved" do
          skip
          board = Board.new
          black_king = board.board[4][7]
          board.board[5][7] = nil
          board.board[6][7] = nil
          expect(board.can_castle_right?(black_king)).to be true
        end

        it "should return false when any squares passed over by the king are under attack" do
          skip
          board = Board.new
          black_king = board.board[4][7]
          board.board[5][7] = nil
          board.board[6][7] = nil
          board.board[5][6] = Rook.new(:white, [5, 6], board)
          expect(board.can_castle_right?(black_king)).to be false
          board.board[6][6] = Rook.new(:white, [6, 6], board)
          board.board[3][1] = nil
          expect(board.can_castle_right?(black_king)).to be false
        end

        it "should return false when king has moved" do
          skip
          board = Board.new
          board.board[5][7] = nil
          board.board[6][7] = nil
          black_king = board.board[4][7]
          black_king.first_move = false
          expect(board.can_castle_right?(black_king)).to be false
        end

        it "should return false when rook has moved" do
          skip
          board = Board.new
          board.board[5][7] = nil
          board.board[6][7] = nil
          black_king = board.board[4][7]
          board.right_black_rook.first_move = false
          expect(board.can_castle_right?(black_king)).to be false
        end
      end
    end

    describe "#king_in_check?" do
      it "should return false when king is not in check" do
        board = Board.new
        expect(board.king_in_check?(:white)).to be false
      end

      it "should return true when king is in check" do
        board.board[4][1] = Rook.new(:black, [4, 1], board)
        expect(board.king_in_check?(:white)).to be true
      end
    end

    describe "#causes_check?" do
      it "should return true when white piece makes move that puts white king in check" do
        skip
        board = Board.new
        board.board[7][3] = Bishop.new(:black, [7, 3], board)
        expect(board.causes_check?(board.board[5][1], [5, 2])).to be true
      end

      it "should return true when black piece makes move that puts black king in check" do
        skip
        board.board[1][4] = Bishop.new(:white, [1, 4], board)
        expect(board.causes_check?(board.board[3][6], [3, 5])).to be true
      end
    end
  end

  context "getting move lists" do # Probably doesn't need to be tested if properly tested in individual piece classes
    describe "#get_moves" do
    end
  end

  context "moving pieces" do
    context "standard move" do
      describe "#move_piece" do
        it "should correctly move white pawn up one square" do
          board = Board.new
          white_pawn = board.board[0][1]
          board.move_piece(white_pawn, [0, 2])
          expect(board.board[0][2]).to eq(white_pawn)
        end

        it "should correctly move white pawn up 2 squares" do
          board = Board.new
          white_pawn = board.board[0][1]
          board.move_piece(white_pawn, [0, 3])
          expect(board.board[0][3]).to eq(white_pawn)
        end

        it "should correctly move black pawn down 1 square" do
          board = Board.new
          black_pawn = board.board[0][6]
          board.move_piece(black_pawn, [0, 5])
          expect(board.board[0][5]).to eq(black_pawn)
        end

        it "should correctly move black pawn down 2 squares" do
          board = Board.new
          black_pawn = board.board[0][6]
          board.move_piece(black_pawn, [0, 4])
          expect(board.board[0][4]).to eq(black_pawn)
        end

        it "should correctly move knight" do
          knight = board.board[1][0]
          board.move_piece(knight, [2, 2])
          expect(board.board[2][2]).to eq(knight)
        end

        it "should empty square at piece's old location" do
          board = Board.new
          board.move_piece(board.board[0][1], [0, 3])
          board.move_piece(board.board[0][6], [0, 5])
          board.move_piece(board.board[1][0], [2, 2])
          expect(board.board[0][1]).to be nil
          expect(board.board[0][6]).to be nil
          expect(board.board[1][0]).to be nil
        end
      end
    end

    context "en passant" do
      describe "#passant_capture?" do
        it "should return true when initiating a passant capture" do
          skip
          board = Board.new
          board.move_piece(board.board[0][1], [0, 3])
          expect(board.passant_capture?([0, 2], :black)).to be true
        end

        it "should return false when move is not made immediately after pawn moves 2 forward" do
          skip
          board.passant_pawn = nil
          expect(board.passant_capture?([0, 2], :black)).to be false
        end
      end

      describe "#passant_check" do
        board = Board.new
        white_pawn = board.board[0][1]
        black_pawn = board.board[0][6]
        it "should correctly place passant opening when one is created by a white pawn" do
          skip
          board.passant_check(white_pawn, [0, 3])
          expect(board.passant_pawn.location).to eq([0, 2])
        end

        it "should correctly place passant opening when one is created by a black pawn" do
          skip
          board.passant_check(black_pawn, [0, 4])
          expect(board.passant_pawn.location).to eq([0, 5])
        end

        it "should remove captured piece from board after en passant capture" do
          skip
          board.board[0][4] = Pawn.new(:black, [0, 4])
          board.board[1][4] = Pawn.new(:white, [1, 4])
          board.passant_check(board.board[1][4], [0, 5])
          expect(board.board[0][4]).to be nil
        end
      end
    end
  end
end

context "trash" do

  # context "from pawns" do
  #   it "should list 2 moves on pawn's first move with clear path" do
  #     board = Board.new
  #     pawn = board.board[3][1]
  #     expect(board.get_moves(pawn).size).to be 2
  #   end

  #   it "should only list 1 move: forward 1 square, when not first move" do
  #     pawn = board.board[3][1]
  #     pawn.first_move = false
  #     expect(board.get_moves(pawn).size).to be 1
  #     expect(board.get_moves(pawn)).to eq [[3, 2]]
  #   end

  #   it "should list no moves when enemy piece is right in front with no capture possibilities" do
  #     board = Board.new
  #     pawn = board.board[3][1]
  #     board.board[3][2] = Pawn.new(:black, [3, 2])
  #     expect(board.get_moves(pawn)).to eq []
  #   end

  #   it "should list no moves when friendly piece is right in front with no capture possibilities" do
  #     board = Board.new
  #     pawn = board.board[3][1]
  #     board.board[3][2] = Pawn.new(:white, [3, 2])
  #     expect(board.get_moves(pawn)).to eq []
  #   end

  #   it "should list 4 possible moves on first move with 2 possible captures" do
  #     board = Board.new
  #     pawn = board.board[3][1]
  #     board.board[3][2] = nil
  #     board.board[2][2] = Pawn.new(:black, [2, 2])
  #     board.board[4][2] = Pawn.new(:black, [4, 2])
  #     expect(board.get_moves(pawn).size).to eq 4
  #   end
  # end
  # describe "#in_bounds?" do # Redundant, checked in game class
  #   it "should return false when x coordinate is out of bounds" do
  #     expect(board.in_bounds?([9, 1])).to be false
  #   end

  #   it "should return false when y coordinate is out of bounds" do
  #     expect(board.in_bounds?([1, 9])).to be false
  #   end

  #   it "should return true when both x and y are in bounds" do
  #     expect(board.in_bounds?([2, 2])).to be true
  #   end
  # end

  # describe "#square_empty?" do # Most likely redundant after creating check_square function
  #   it "should return true when there is no piece at destination" do
  #     expect(board.square_empty?([3, 3])).to be true
  #   end

  #   it "should return false when destination is occupied" do
  #     expect(board.square_empty?([0, 0])).to be false
  #   end
  # end

  # describe "#current_players_piece?" do # Most likely redundant after creating check_square function
  #   # Remove player instances and piece variables
  #   it "should return true when player 1 selects a white piece" do
  #     expect(board.current_players_piece?(board.board[0][1], :white)).to eq true
  #   end

  #   it "should return false when player 2 selects a white piece" do
  #     expect(board.current_players_piece?(board.board[0][1], :black)).to eq false
  #   end

  #   it "should return true when player 2 selects a black piece" do
  #     expect(board.current_players_piece?(board.board[0][6], :black)).to eq true
  #   end

  #   it "should return false when player 1 selects a black piece" do
  #     expect(board.current_players_piece?(board.board[0][6], :white)).to eq false
  #   end
  # end

  # describe "#get_white_positions" do # Function probably not needed
      #   white_positions = board.get_white_positions

      #   it "should return an array" do
      #     expect(white_positions).to be_a(Array)
      #   end

      #   it "should only contain squares occupied by white pieces" do
      #     expect(board.board[white_positions[0][0]][white_positions[0][1]].color).to be(:white)
      #     expect(board.board[white_positions[7][0]][white_positions[7][1]].color).to be(:white)
      #     expect(board.board[white_positions.last[0]][white_positions.last[1]].color).to be(:white)
      #   end
      # end

      # describe "#get_black_positions" do # Function probably not needed
      #   black_positions = board.get_black_positions

      #   it "should return an array" do
      #     expect(black_positions).to be_a(Array)
      #   end

      #   it "should only contain squares occupied by black pieces" do
      #     expect(board.board[black_positions[0][0]][black_positions[0][1]].color).to be(:black)
      #     expect(board.board[black_positions[7][0]][black_positions[7][1]].color).to be(:black)
      #     expect(board.board[black_positions.last[0]][black_positions.last[1]].color).to be(:black)
      #   end
      # end

      # describe "#path_obstructed?" do # Probably won't be needed after all piece types have moves properly implemented
      #   context "checking knight paths" do
      #     board = Board.new
      #     knight = board.board[1][0]
      #     it "should return true when destination occupied by friendly piece" do
      #       expect(board.path_obstructed?(knight, [3, 1])).to eq true
      #     end

      #     it "should return false when destination is unoccupied" do
      #       expect(board.path_obstructed?(knight, [3, 2])).to eq false
      #     end

      #     it "should return false when destination is occupied by enemy piece" do
      #       board.board[2][2] = Pawn.new(:black, [2, 2])
      #       expect(board.path_obstructed?(knight, [2, 2])).to eq false
      #     end
      #   end

      #   context "checking pawn paths" do
      #     board = Board.new
      #     pawn = board.board[3][1]

      #     it "should return false when destination is unoccupied" do
      #       expect(board.path_obstructed?(pawn, [3, 2])).to eq false
      #     end

      #     it "should return true when destination occupied by friendly piece" do
      #       board.board[3][2] = Knight.new(:white, [3, 2])
      #       expect(board.path_obstructed?(pawn, [3, 2])).to eq true
      #     end

      #     it "should return false when destination is occupied by enemy piece" do
      #       board.board[3][2] = Pawn.new(:black, [3, 2])
      #       expect(board.path_obstructed?(pawn, [3, 2])).to eq false
      #     end
      #   end

      #   context "check queen paths" do
      #     board = Board.new
      #     queen = board.board[3][0]

      #     it "should return false when destination is unoccupied" do
      #       board.board[3][1] = nil
      #       expect(board.path_obstructed?(queen, [3, 1])).to eq false
      #     end

      #     it "should return true when destination occupied by friendly piece" do
      #       board.board[3][2] = Knight.new(:white, [3, 2])
      #       expect(board.path_obstructed?(queen, [3, 2])).to eq true
      #     end

      #     it "should return false when destination is occupied by enemy piece" do
      #       board.board[3][2] = Pawn.new(:black, [3, 2])
      #       expect(board.path_obstructed?(queen, [3, 2])).to eq false
      #     end
      #   end
      # end



    # context "pawn captures" do # Possibly redundant
    #   describe "#pawn_possible_captures" do
    #     context "white pawns" do
    #       it "should return an empty array when there are no pieces to capture" do
    #         board = Board.new
    #         expect(board.pawn_possible_captures(board.board[3][1])).to eq []
    #       end

    #       it "should return an empty array when friendly pieces are at capture spots" do
    #         board.board[2][2] = Pawn.new(:white, [2, 2])
    #         board.board[4][2] = Pawn.new(:white, [4, 2])
    #         expect(board.pawn_possible_captures(board.board[3][1])).to eq []
    #       end

    #       it "should only return coordinates containing enemy pieces" do
    #         board.board[2][2] = Pawn.new(:black, [2, 2])
    #         expect(board.pawn_possible_captures(board.board[3][1])).to eq([[2, 2]])
    #       end

    #       it "should show both captures if there are two" do
    #         board.board[4][2] = Pawn.new(:black, [4, 2])
    #         expect(board.pawn_possible_captures(board.board[3][1])).to include([4, 2], [2, 2])
    #       end
    #     end

    #     context "black pawns" do
    #       it "should return an empty array when there are no pieces to capture" do
    #         board = Board.new
    #         expect(board.pawn_possible_captures(board.board[3][6])).to eq []
    #       end

    #       it "should return an empty array when friendly pieces are at capture spots" do
    #         board.board[2][5] = Pawn.new(:black, [2, 5])
    #         board.board[4][5] = Pawn.new(:black, [4, 5])
    #         expect(board.pawn_possible_captures(board.board[3][6])).to eq []
    #       end

    #       it "should only return coordinates containing enemy pieces" do
    #         board.board[2][5] = Pawn.new(:white, [2, 5])
    #         expect(board.pawn_possible_captures(board.board[3][6])).to eq([[2, 5]])
    #       end

    #       it "should show both captures if there are two" do
    #         board.board[4][5] = Pawn.new(:white, [4, 5])
    #         expect(board.pawn_possible_captures(board.board[3][6])).to include([4, 5], [2, 5])
    #       end
    #     end
    #   end
    # end
end