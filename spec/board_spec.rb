require './lib/board.rb'

describe Board do
  context "starting state of board" do
    board = Board.new
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
        expect(board.board[0][7]).to be_an_instance_of(Rook)
        expect(board.board[7][7]).to be_an_instance_of(Rook)
      end

      it "should place black knights in correct starting positions" do
        expect(board.board[1][7]).to be_an_instance_of(Knight)
        expect(board.board[6][7]).to be_an_instance_of(Knight)
      end

      it "should place black bishops in correct starting positions" do
        expect(board.board[2][7]).to be_an_instance_of(Bishop)
        expect(board.board[5][7]).to be_an_instance_of(Bishop)
      end

      it "should place black queen in correct starting position" do
        expect(board.board[3][7]).to be_an_instance_of(Queen)
      end

      it "should place black king in correct starting position" do
        expect(board.board[4][7]).to be_an_instance_of(King)
      end
    end
  end

  context "checking game state" do
    board = Board.new
    describe "#square_under_attack?" do
      it "should return false when no enemy piece can move to square in question" do
        expect(board.square_under_attack?([0, 3], :white)).to be false
      end
    end

    describe "#promotion?" do
      it "should return true when white pawn reaches far end of board" do
        board.board[0][7] = Pawn.new(:white, [0, 7], board)
        expect(board.promotion?(board.board[0][7])).to be true
      end

      it "should return true when black pawn reaches far end of board" do
        board.board[0][0] = Pawn.new(:black, [0, 0], board)
        expect(board.promotion?(board.board[0][0])).to be true
      end

      it "should return false when pawn has not reached opposite end" do
        expect(board.promotion?(board.board[2][1])).to be false
      end
    end

    describe "#get_enemy_list" do
      board = Board.new
      it "should only return black piece coordinates when checking for white" do
        black_pieces = board.get_enemy_list(:white)
        actual = black_pieces.all?{|coords| board.board[coords[0]][coords[1]].color == :black}
        expect(actual).to be true
      end
  
      it "should only return white piece coordinates when checking for black" do
        white_pieces = board.get_enemy_list(:black)
        actual = white_pieces.all?{|coords| board.board[coords[0]][coords[1]].color == :white}
        expect(actual).to be true
      end
    end
  end

  context "validating moves" do
    board = Board.new
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
        expect(board.valid_selection?([0, 0], :white)).to be false
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

      it "should return 'en passant' when the square is a passant opening" do
        board.passant_opening = [0, 2]
        expect(board.check_square([0, 2], :white)).to eq 'en passant'
      end
    end

    describe "#can_castle_left?" do
      context "white side" do
        it "should return false when any squares between are occupied" do
          board = Board.new
          white_king = board.board[4][0]
          expect(board.can_castle_left?(white_king)).to be false
        end

        it "should return true when squares between corresponding rook and king are empty and neither have moved" do
          board = Board.new
          white_king = board.board[4][0]
          board.board[3][0] = nil
          board.board[2][0] = nil
          board.board[1][0] = nil
          expect(board.can_castle_left?(white_king)).to be true
        end

        it "should return false when any squares passed over by the king are under attack" do
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
          board = Board.new
          board.board[3][0] = nil
          board.board[2][0] = nil
          board.board[1][0] = nil
          white_king = board.board[4][0]
          board.move_piece(white_king, [4, 1])
          expect(board.can_castle_left?(white_king)).to be false
        end

        it "should return false when rook has moved" do
          board = Board.new
          board.board[3][0] = nil
          board.board[2][0] = nil
          board.board[1][0] = nil
          white_king = board.board[4][0]
          board.move_piece(board.board[0][0], [0, 1])
          expect(board.can_castle_left?(white_king)).to be false
        end
      end

      context "black side" do
        it "should return false when any squares between are occupied" do
          board = Board.new
          black_king = board.board[4][7]
          expect(board.can_castle_left?(black_king)).to be false
        end

        it "should return true when squares between corresponding rook and king are empty and neither have moved" do
          board = Board.new
          black_king = board.board[4][7]
          board.board[3][7] = nil
          board.board[2][7] = nil
          board.board[1][7] = nil
          expect(board.can_castle_left?(black_king)).to be true
        end

        it "should return false when any squares passed over by the king are under attack" do
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
          board = Board.new
          board.board[3][7] = nil
          board.board[2][7] = nil
          board.board[1][7] = nil
          black_king = board.board[4][7]
          board.move_piece(black_king, [4, 6])
          expect(board.can_castle_left?(black_king)).to be false
        end

        it "should return false when rook has moved" do
          board = Board.new
          board.board[3][7] = nil
          board.board[2][7] = nil
          board.board[1][7] = nil
          black_king = board.board[4][7]
          board.move_piece(board.board[0][7], [0, 6])
          expect(board.can_castle_left?(black_king)).to be false
        end
      end
    end

    describe "#can_castle_right?" do
      context "white side" do
        it "should return false when any squares between are occupied" do
          board = Board.new
          white_king = board.board[4][0]
          expect(board.can_castle_right?(white_king)).to be false
        end

        it "should return true when squares between corresponding rook and king are empty and neither have moved" do
          board = Board.new
          white_king = board.board[4][0]
          board.board[5][0] = nil
          board.board[6][0] = nil
          expect(board.can_castle_right?(white_king)).to be true
        end

        it "should return false when any squares passed over by the king are under attack" do
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
          board = Board.new
          board.board[5][0] = nil
          board.board[6][0] = nil
          white_king = board.board[4][0]
          #white_king.first_move = false
          board.move_piece(white_king, [5, 0])
          expect(board.can_castle_right?(white_king)).to be false
        end

        it "should return false when rook has moved" do
          board = Board.new
          board.board[5][0] = nil
          board.board[6][0] = nil
          white_king = board.board[4][0]
          board.move_piece(board.board[7][0], [7, 1])
          expect(board.can_castle_right?(white_king)).to be false
        end
      end

      context "black side" do
        it "should return false when any squares between are occupied" do
          board = Board.new
          black_king = board.board[4][7]
          expect(board.can_castle_right?(black_king)).to be false
        end

        it "should return true when squares between corresponding rook and king are empty and neither have moved" do
          board = Board.new
          black_king = board.board[4][7]
          board.board[5][7] = nil
          board.board[6][7] = nil
          expect(board.can_castle_right?(black_king)).to be true
        end

        it "should return false when any squares passed over by the king are under attack" do
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
          board = Board.new
          board.board[5][7] = nil
          board.board[6][7] = nil
          black_king = board.board[4][7]
          board.move_piece(black_king, [4, 6])
          expect(board.can_castle_right?(black_king)).to be false
        end

        it "should return false when rook has moved" do
          board = Board.new
          board.board[5][7] = nil
          board.board[6][7] = nil
          black_king = board.board[4][7]
          board.move_piece(board.board[7][7], [6, 7])
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
  end

  context "moving pieces" do
    context "checking move type" do
      board = Board.new
      describe "#move_type" do
        it "should return 'pawn 2' when a pawn is moving 2 squares forward" do
          expect(board.move_type(board.board[0][1], [0, 3])).to eq 'pawn 2'
        end

        it "should return 'standard' when a pawn is only moving 1 square forward" do
          expect(board.move_type(board.board[0][1], [0, 2])).to eq 'standard'
        end

        it "should return 'king' when a king is moving" do
          expect(board.move_type(board.board[4][0], [4, 1])).to eq 'king'
        end

        it "should return 'rook' when a rook is moving" do
          expect(board.move_type(board.board[0][0], [0, 1])).to eq 'rook'
        end

        it "should return 'passant capture' when a passant capture is being initiated" do
          board.board[1][3] = Pawn.new(:black, [1, 3], board)
          board.move_piece(board.board[0][1], [0, 3])
          expect(board.move_type(board.board[1][3], [0, 2])).to eq 'passant capture'
        end

        it "should return 'standard' when a queen is moving" do
          expect(board.move_type(board.board[3][0], [3, 1])).to eq 'standard'
        end

        it "should return 'standard' when a bishop is moving" do
          expect(board.move_type(board.board[2][0], [3, 1])).to eq 'standard'
        end
      end
    end

    context "rook move" do
      board = Board.new
      describe "#rook_move" do
        rook = board.board[0][0]
        it "should move rook to intended destination" do
          board.move_piece(rook, [0, 3])
          expect(board.board[0][3]).to eq rook
        end

        it "should clear square at rook's previous location" do
          expect(board.board[0][0]).to be nil
        end

        it "should update rook's location" do
          expect(rook.location).to eq [0, 3]
        end
      end
    end

    context "castling" do
      board = Board.new
      describe "#left_castle?" do
        it "should return true when white king is moving 2 spaces to the left" do
          expect(board.left_castle?([2, 0])).to be true
        end

        it "should return true when black king is moving 2 spaces to the left" do
          expect(board.left_castle?([2, 7])).to be true
        end

        it "should return false when white king is only moving one space to the left" do
          expect(board.left_castle?([3, 0])).to be false
        end

        it "should return false when black king is only moving one space to the left" do
          expect(board.left_castle?([3, 7])).to be false
        end
      end

      describe "#right_castle?" do
        it "should return true when white king is moving 2 spaces to the right" do
          expect(board.right_castle?([6, 0])).to be true
        end

        it "should return true when black king is moving 2 spaces to the right" do
          expect(board.right_castle?([6, 7])).to be true
        end

        it "should return false when white king is only moving one space to the right" do
          expect(board.right_castle?([5, 0])).to be false
        end

        it "should return false when black king is only moving one space to the right" do
          expect(board.right_castle?([5, 7])).to be false
        end
      end

      describe "#castle_left" do
        context "white side" do
          white_king = board.board[4][0]
          left_white_rook = board.board[0][0]
          it "should move the white king 2 spaces to the left" do
            board.castle_left(white_king)
            expect(board.board[2][0]).to eq white_king
          end

          it "should clear square at white king's previous location" do
            expect(board.board[4][0]).to be nil
          end

          it "should update white king pieces location" do
            expect(white_king.location).to eq [2, 0]
          end

          it "should move left white rook to other side of king" do
            expect(board.board[3][0]).to eq left_white_rook
          end

          it "should clear square at left white rook's previous location" do
            expect(board.board[0][0]).to be nil
          end

          it "should update left white rook's location" do
            expect(left_white_rook.location).to eq [3, 0]
          end
        end

        context "black side" do
          black_king = board.board[4][7]
          left_black_rook = board.board[0][7]
          it "should move the black king 2 spaces to the left" do
            board.castle_left(black_king)
            expect(board.board[2][7]).to eq black_king
          end

          it "should clear square at black king's previous location" do
            expect(board.board[4][7]).to be nil
          end

          it "should update black king pieces location" do
            expect(black_king.location).to eq [2, 7]
          end

          it "should move left black rook to other side of king" do
            expect(board.board[3][7]).to eq left_black_rook
          end

          it "should clear square at left black rook's previous location" do
            expect(board.board[0][7]).to be nil
          end

          it "should update left black rook's location" do
            expect(left_black_rook.location).to eq [3, 7]
          end
        end
      end

      describe "#castle_right" do
        context "white side" do
          white_king = board.board[4][0]
          right_white_rook = board.board[7][0]
          it "should move the white king 2 spaces to the right" do
            board.castle_right(white_king)
            expect(board.board[6][0]).to eq white_king
          end

          it "should clear square at white king's previous location" do
            expect(board.board[4][0]).to be nil
          end

          it "should update white king pieces location" do
            expect(white_king.location).to eq [6, 0]
          end

          it "should move right white rook to other side of king" do
            expect(board.board[5][0]).to eq right_white_rook
          end

          it "should clear square at right white rook's previous location" do
            expect(board.board[7][0]).to be nil
          end

          it "should update right white rook's location" do
            expect(right_white_rook.location).to eq [5, 0]
          end
        end

        context "black side" do
          black_king = board.board[4][7]
          right_black_rook = board.board[7][7]
          it "should move the black king 2 spaces to the right" do
            board.castle_right(black_king)
            expect(board.board[6][7]).to eq black_king
          end

          it "should clear square at black king's previous location" do
            expect(board.board[4][7]).to be nil
          end

          it "should update black king pieces location" do
            expect(black_king.location).to eq [6, 7]
          end

          it "should move right black rook to other side of king" do
            expect(board.board[5][7]).to eq right_black_rook
          end

          it "should clear square at right black rook's previous location" do
            expect(board.board[0][7]).to be nil
          end

          it "should update right black rook's location" do
            expect(right_black_rook.location).to eq [5, 7]
          end
        end
      end
    end

    context "standard move" do
      
    end

    context "en passant" do
      board = Board.new
      white_pawn = board.board[0][1]
      black_pawn = board.board[0][6]
      describe "#move_pawn_2" do
        context "white pawn" do
          it "should move white pawn 2 squares up" do
            board.move_pawn_2(white_pawn, [0, 3])
            expect(board.board[0][3]).to eq(white_pawn)
          end

          it "should clear square at white pawn's original location" do
            expect(board.board[0][1]).to be nil
          end

          it "should update pawn's location" do
            expect(white_pawn.location).to eq([0, 3])
          end

          it "should set passant_opening to one square behind white pawn" do
            expect(board.passant_opening).to eq([0, 2])
          end
        end

        context "black pawn" do
          it "should move black pawn 2 squares up" do
            board.move_pawn_2(black_pawn, [0, 4])
            expect(board.board[0][4]).to eq(black_pawn)
          end

          it "should clear square at black pawn's original location" do
            expect(board.board[0][6]).to be nil
          end

          it "should update pawn's location" do
            expect(black_pawn.location).to eq([0, 4])
          end

          it "should set passant_opening to one square behind black pawn" do
            expect(board.passant_opening).to eq([0, 5])
          end
        end
      end
      describe "#passant_capture?" do
        it "should return true when initiating a passant capture" do
          board = Board.new
          board.passant_opening = [0, 2]
          expect(board.passant_capture?([0, 2])).to be true
        end

        it "should return false when move is not made immediately after pawn moves 2 forward" do
          expect(board.passant_capture?([0, 3])).to be false
        end
      end

      describe "#passant_vulnerable?" do
        it "should return true when a white pawn moves 2 spaces forward" do
          board = Board.new
          expect(board.passant_vulnerable?(board.board[0][1], [0, 3])).to be true
        end

        it "should return true when a black pawn moves 2 spaces forward" do
          expect(board.passant_vulnerable?(board.board[0][6], [0, 4])).to be true
        end

        it "should return false when a white pawn only moves one space forward" do
          expect(board.passant_vulnerable?(board.board[0][1], [0, 2])).to be false
        end

        it "should return false when a black pawn only moves one space forward" do
          expect(board.passant_vulnerable?(board.board[0][6], [0, 5])).to be false
        end
      end

      describe "#en_passant_capture" do
        it "should remove captured piece from board" do
          board = Board.new
          board.board[1][3] = Pawn.new(:black, [1, 3], board)
          black_pawn = board.board[1][3]
          white_pawn = board.board[0][1]
          board.move_piece(white_pawn, [0, 3])
          board.en_passant_capture(black_pawn, [0, 2])
          expect(board.board[0][3]).to be nil
        end
      end
    end
  end
end

context "trash" do
  #   describe "#move_piece" do
  #   it "should correctly move white pawn up one square" do
  #     board = Board.new
  #     white_pawn = board.board[0][1]
  #     board.move_piece(white_pawn, [0, 2])
  #     expect(board.board[0][2]).to eq(white_pawn)
  #   end

  #   it "should correctly move white pawn up 2 squares" do
  #     board = Board.new
  #     white_pawn = board.board[0][1]
  #     board.move_piece(white_pawn, [0, 3])
  #     expect(board.board[0][3]).to eq(white_pawn)
  #   end

  #   it "should correctly move black pawn down 1 square" do
  #     board = Board.new
  #     black_pawn = board.board[0][6]
  #     board.move_piece(black_pawn, [0, 5])
  #     expect(board.board[0][5]).to eq(black_pawn)
  #   end

  #   it "should correctly move black pawn down 2 squares" do
  #     board = Board.new
  #     black_pawn = board.board[0][6]
  #     board.move_piece(black_pawn, [0, 4])
  #     expect(board.board[0][4]).to eq(black_pawn)
  #   end

  #   it "should correctly move knight" do
  #     knight = board.board[1][0]
  #     board.move_piece(knight, [2, 2])
  #     expect(board.board[2][2]).to eq(knight)
  #   end

  #   it "should empty square at piece's old location" do
  #     board = Board.new
  #     board.move_piece(board.board[0][1], [0, 3])
  #     board.move_piece(board.board[0][6], [0, 5])
  #     board.move_piece(board.board[1][0], [2, 2])
  #     expect(board.board[0][1]).to be nil
  #     expect(board.board[0][6]).to be nil
  #     expect(board.board[1][0]).to be nil
  #   end
  # end

  # describe "#causes_check?" do
  #   it "should return true when white piece makes move that puts white king in check" do
  #     skip
  #     board = Board.new
  #     board.board[7][3] = Bishop.new(:black, [7, 3], board)
  #     expect(board.causes_check?(board.board[5][1], [5, 2])).to be true
  #   end

  #   it "should return true when black piece makes move that puts black king in check" do
  #     skip
  #     board.board[1][4] = Bishop.new(:white, [1, 4], board)
  #     expect(board.causes_check?(board.board[3][6], [3, 5])).to be true
  #   end
  # end

  # describe "#passant_check" do
  #   board = Board.new
  #   white_pawn = board.board[0][1]
  #   black_pawn = board.board[0][6]
  #   it "should correctly place passant opening when one is created by a white pawn" do
  #     skip
  #     board.passant_check(white_pawn, [0, 3])
  #     expect(board.passant_pawn.location).to eq([0, 2])
  #   end

  #   it "should correctly place passant opening when one is created by a black pawn" do
  #     skip
  #     board.passant_check(black_pawn, [0, 4])
  #     expect(board.passant_pawn.location).to eq([0, 5])
  #   end

  #   it "should remove captured piece from board after en passant capture" do
  #     skip
  #     board.board[0][4] = Pawn.new(:black, [0, 4])
  #     board.board[1][4] = Pawn.new(:white, [1, 4])
  #     board.passant_check(board.board[1][4], [0, 5])
  #     expect(board.board[0][4]).to be nil
  #   end
  # end

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