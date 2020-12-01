require './lib/pieces/queen.rb'

describe Queen do
  describe "#initialize" do
    board = Board.new
    white_queen = Queen.new(:white, [3, 0], board)
    black_queen = Queen.new(:black, [3, 7], board)

    it "should create a queen piece with the color white" do
      expect(white_queen.color).to eq(:white)
    end

    it "should create a queen piece with the color black" do
      expect(black_queen.color).to eq(:black)
    end

    it "should assign ♛ as the white queen's symbol" do
      expect(white_queen.symbol).to eq('♛')
    end

    it "should assign ♕ as the black queen's symbol" do
      expect(black_queen.symbol).to eq('♕')
    end
  end

  context "getting moves" do
    describe "#vertical_moves" do
      context "moving up" do
        board = Board.new
        board.board[5][3] = Queen.new(:white, [5, 3], board)
        white_queen = board.board[5][3]

        it "should return no moves when blocked in by friendly pieces" do
          expect(board.board[3][0].vertical_moves).to eq([])
        end

        it "should include enemy locations on it's path" do
          expect(white_queen.vertical_moves).to include([5, 6])
        end

        it "should stop adding moves when reaching a non-empty square" do
          expect(white_queen.vertical_moves).not_to include([5, 7])
        end
        
        it "should not return moves that are out of bounds" do
          board.board[5][6] = nil
          board.board[5][7] = nil
          actual = white_queen.vertical_moves.any? { |move| move.any? {|i| i < 0 || i > 7 } }
          expect(actual).to be false
        end
      end

      context "moving down" do
        board = Board.new
        board.board[2][4] = Queen.new(:black, [2, 4], board)
        black_queen = board.board[2][4]

        it "should return no moves when blocked in by friendly pieces" do
          expect(board.board[3][7].vertical_moves).to eq([])
        end

        it "should include enemy locations on it's path" do
          expect(black_queen.vertical_moves).to include([2, 1])
        end

        it "should stop adding moves when reaching a non-empty square" do
          expect(black_queen.vertical_moves).not_to include([2, 0])
        end
        
        it "should not return moves that are out of bounds" do
          board.board[2][1] = nil
          board.board[2][0] = nil
          actual = black_queen.vertical_moves.any? { |move| move.any? {|i| i < 0 || i > 7 } }
          expect(actual).to be false
        end
      end
    end

    describe "#horizontal_moves" do
      context "moving left" do
        board = Board.new
        board.board[5][3] = Queen.new(:white, [5, 3], board)
        white_queen = board.board[5][3]
        board.board[2][3] = Queen.new(:black, [2, 3], board)
    
        it "should return no moves when blocked in by friendly pieces" do
          expect(board.board[3][0].horizontal_moves).to eq([])
        end
    
        it "should include enemy locations on it's path" do
          expect(white_queen.horizontal_moves).to include([2, 3])
        end
    
        it "should stop adding moves when reaching a non-empty square" do
          expect(white_queen.horizontal_moves).not_to include([1, 3])
        end
        
        it "should not return moves that are out of bounds" do
          board.board[2][3] = nil
          actual = white_queen.horizontal_moves.any? { |move| move.any? {|i| i < 0 || i > 7 } }
          expect(actual).to be false
        end
      end

      context "moving right" do
        board = Board.new
        board.board[2][4] = Queen.new(:black, [2, 4], board)
        board.board[5][4] = Queen.new(:white, [5, 4], board)
        black_queen = board.board[2][4]
    
        it "should return no moves when blocked in by friendly pieces" do
          expect(board.board[3][7].horizontal_moves).to eq([])
        end
    
        it "should include enemy locations on it's path" do
          expect(black_queen.horizontal_moves).to include([5, 4])
        end
    
        it "should stop adding moves when reaching a non-empty square" do
          expect(black_queen.horizontal_moves).not_to include([6, 4])
        end
        
        it "should not return moves that are out of bounds" do
          board.board[5][4] = nil
          actual = black_queen.horizontal_moves.any? { |move| move.any? {|i| i < 0 || i > 7 } }
          expect(actual).to be false
        end
      end
    end

    describe "#up_diagonal_moves" do
      board = Board.new
      board.board[5][3] = Queen.new(:white, [5, 3], board)
      white_queen = board.board[5][3]

      it "should return no moves when blocked in by friendly pieces" do
        expect(board.board[3][0].up_diagonal_moves).to eq([])
      end

      it "should include both left and right diagonal moves" do
        expect(white_queen.up_diagonal_moves).to include([4, 4], [6, 4])
      end

      it "should continue adding to one path even after another has ended" do
        expect(white_queen.up_diagonal_moves).to include([2, 6])
      end

      it "should include enemy locations on it's path" do
        expect(white_queen.up_diagonal_moves).to include([2, 6])
      end

      it "should stop adding moves when reaching a non-empty square" do
        expect(white_queen.up_diagonal_moves).not_to include([1, 7])
      end

      it "should not return moves that are out of bounds" do
        actual = white_queen.up_diagonal_moves.any? { |move| move.any? {|i| i < 0 || i > 7 } }
        expect(actual).to be false
      end
    end

    describe "#down_diagonal_moves" do
      board = Board.new
      board.board[2][4] = Queen.new(:black, [2, 4], board)
      black_queen = board.board[2][4]
  
      it "should return no moves when blocked in by friendly pieces" do
        expect(board.board[3][7].down_diagonal_moves).to eq([])
      end
  
      it "should include both left and right diagonal moves" do
        expect(black_queen.down_diagonal_moves).to include([1, 3], [3, 3])
      end
  
      it "should continue adding to one path even after another has ended" do
        expect(black_queen.down_diagonal_moves).to include([5, 1])
      end
  
      it "should include enemy locations on it's path" do
        expect(black_queen.down_diagonal_moves).to include([5, 1])
      end
  
      it "should stop adding moves when reaching a non-empty square" do
        expect(black_queen.down_diagonal_moves).not_to include([6, 0])
      end
  
      it "should not return moves that are out of bounds" do
        actual = black_queen.down_diagonal_moves.any? { |move| move.any? {|i| i < 0 || i > 7 } }
        expect(actual).to be false
      end
    end
  end
end