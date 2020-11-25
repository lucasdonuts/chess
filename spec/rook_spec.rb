require './lib/pieces/rook.rb'

describe Rook do
  describe "#initialize" do
    board = Board.new
    white_rook = Rook.new(:white, [0, 0], board)
    black_rook = Rook.new(:black, [0, 7], board)

    it "should create a rook piece with the color white" do
      expect(white_rook.color).to eq(:white)
    end

    it "should create a rook piece with the color black" do
      expect(black_rook.color).to eq(:black)
    end

    it "should assign ♜ as the white rook's symbol" do
      expect(white_rook.symbol).to eq('♜')
    end

    it "should assign ♖ as the black rook's symbol" do
      expect(black_rook.symbol).to eq('♖')
    end
  end

  context "getting moves" do
    describe "#vertical_moves" do
      context "moving up" do
        board = Board.new
        white_rook = board.board[0][0]
        
        it "should return no moves when blocked in by friendly pieces" do
          expect(white_rook.vertical_moves).to eq([])
        end

        it "should include enemy locations on it's path" do
          board.board[0][1] = nil
          expect(white_rook.vertical_moves).to include([0, 6])
        end

        it "should stop adding moves when reaching a non-empty square" do
          expect(white_rook.vertical_moves).not_to include([0, 7])
        end

        it "should not return moves that are out of bounds" do
          board.board[0][6] = nil
          board.board[0][7] = nil
          actual = board.board[0][0].vertical_moves.any? { |move| move.any? {|i| i < 0 || i > 7 } }
          expect(actual).to be false
        end
      end

      context "moving down" do
        board = Board.new
        black_rook = board.board[0][7]
        it "should return no moves when blocked in by friendly pieces" do
          expect(black_rook.vertical_moves).to eq([])
        end

        it "should include enemy locations on it's path" do
          board.board[0][6] = nil
          expect(black_rook.vertical_moves).to include([0, 1])
        end

        it "should stop adding moves when reaching a non-empty square" do
          expect(black_rook.vertical_moves).not_to include([0, 0])
        end

        it "should not return moves that are out of bounds" do
          board.board[0][1] = nil
          board.board[0][0] = nil
          actual = black_rook.vertical_moves.any? { |move| move.any? {|i| i < 0 || i > 7 } }
          expect(actual).to be false
        end
      end
    end

    describe "#horizontal_moves" do
      context "moving left" do
        board = Board.new
        board.board[5][3] = Rook.new(:white, [5, 3], board)
        board.board[1][3] = Rook.new(:black, [1, 3], board)
        it "should return no moves when blocked in by friendly pieces" do
          expect(board.board[7][0].horizontal_moves).to eq([])
        end

        it "should include enemy locations on it's path" do
          expect(board.board[5][3].horizontal_moves).to include([1, 3])
        end

        it "should stop adding moves when reaching a non-empty square" do
          expect(board.board[5][3].horizontal_moves).not_to include([0, 3])
        end

        it "should not return moves that are out of bounds" do
          board.board[1][3] = nil
          actual = board.board[5][3].horizontal_moves.any? { |move| move.any? {|i| i < 0 || i > 7 } }
          expect(actual).to be false
        end
      end

      context "moving right" do
        board = Board.new
        board.board[5][3] = Rook.new(:white, [5, 3], board)
        board.board[1][3] = Rook.new(:black, [1, 3], board)
        it "should return no moves when blocked in by friendly pieces" do
          expect(board.board[0][7].horizontal_moves).to eq([])
        end

        it "should include enemy locations on it's path" do
          expect(board.board[1][3].horizontal_moves).to include([5, 3])
        end

        it "should stop adding moves when reaching a non-empty square" do
          expect(board.board[1][3].horizontal_moves).not_to include([6, 3])
          expect(board.board[1][3].horizontal_moves).not_to include([7, 3])
        end

        it "should not return moves that are out of bounds" do
          board.board[5][3] = nil
          actual = board.board[1][3].horizontal_moves.any? { |move| move.any? {|i| i < 0 || i > 7 } }
          expect(actual).to be false
        end
      end
    end
  end
end

describe "trash" do
  # describe "#left_moves" do
  #   board = Board.new
  #   board.board[5][3] = Rook.new(:white, [5, 3])
  #   board.board[1][3] = Rook.new(:black, [1, 3])
  #   it "should return no moves when blocked in by friendly pieces" do
  #     expect(board.board[7][0].horizontal_moves).to eq([])
  #   end

  #   it "should include enemy locations on it's path" do
  #     expect(board.board[5][3].horizontal_moves).to include([1, 3])
  #   end

  #   it "should stop adding moves when reaching a non-empty square" do
  #     expect(board.board[5][3].horizontal_moves).not_to include([0, 3])
  #   end

  #   it "should not return moves that are out of bounds" do
  #     board.board[1][3] = nil
  #     actual = board.board[5][3].horizontal_moves.any? { |move| move.any? {|i| i < 0 || i > 7 } }
  #     expect(actual).to be false
  #   end
  # end

  # describe "#right_moves" do
  #   board = Board.new
  #   board.board[5][3] = Rook.new(:white, [5, 3])
  #   board.board[1][3] = Rook.new(:black, [1, 3])
  #   it "should return no moves when blocked in by friendly pieces" do
  #     expect(board.board[0][7].horizontal_moves).to eq([])
  #   end

  #   it "should include enemy locations on it's path" do
  #     expect(board.board[1][3].horizontal_moves).to include([5, 3])
  #   end

  #   it "should stop adding moves when reaching a non-empty square" do
  #     expect(board.board[1][3].horizontal_moves).not_to include([6, 3])
  #     expect(board.board[1][3].horizontal_moves).not_to include([7, 3])
  #   end

  #   it "should not return moves that are out of bounds" do
  #     board.board[5][3] = nil
  #     actual = board.board[1][3].horizontal_moves.any? { |move| move.any? {|i| i < 0 || i > 7 } }
  #     expect(actual).to be false
  #   end
  # end
  # describe "#up_moves" do
  #   board = Board.new
  #   white_rook = board.board[0][0]
  #   it "should return no moves when blocked in by friendly pieces" do
  #     expect(white_rook.vertical_moves).to eq([])
  #   end

  #   it "should include enemy locations on it's path" do
  #     board.board[0][1] = nil
  #     expect(white_rook.vertical_moves).to include([0, 6])
  #   end

  #   it "should stop adding moves when reaching a non-empty square" do
  #     expect(white_rook.vertical_moves).not_to include([0, 7])
  #   end

  #   it "should not return moves that are out of bounds" do
  #     board.board[0][6] = nil
  #     board.board[0][7] = nil
  #     actual = board.board[0][0].vertical_moves.any? { |move| move.any? {|i| i < 0 || i > 7 } }
  #     expect(actual).to be false
  #   end
  # end

  # describe "#down_moves" do
  #   board = Board.new
  #   black_rook = board.board[0][7]
  #   it "should return no moves when blocked in by friendly pieces" do
  #     expect(black_rook.vertical_moves).to eq([])
  #   end

  #   it "should include enemy locations on it's path" do
  #     board.board[0][6] = nil
  #     expect(black_rook.vertical_moves).to include([0, 1])
  #   end

  #   it "should stop adding moves when reaching a non-empty square" do
  #     expect(black_rook.vertical_moves).not_to include([0, 0])
  #   end

  #   it "should not return moves that are out of bounds" do
  #     board.board[0][1] = nil
  #     board.board[0][0] = nil
  #     actual = black_rook.vertical_moves.any? { |move| move.any? {|i| i < 0 || i > 7 } }
  #     expect(actual).to be false
  #   end
  # end
end