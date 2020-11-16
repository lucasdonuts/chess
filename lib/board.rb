require_relative 'pieces/piece.rb'
require_relative 'pieces/pawn.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/queen.rb'
require_relative 'pieces/king.rb'

class Board
  attr_reader :board

  def initialize
    @board = Array.new(8) { Array.new(8) }
    place_starting_pieces
  end

  def in_bounds?(move)
    (1..8).include?(move[0]) && (1..8).include?(move[1])
  end

  def square_empty?(square)
    @board[square[0]][square[1]].nil?
  end

  def display_board
    puts "\n\n\n                 -   -   -   -   -   -   -   - "
    7.downto(0) do |x|
      print "               | "
      0.upto(7) do |y|
        print board[y][x].nil? ? "  | " : "#{board[y][x].symbol} | "
      end
      print "\n                 -   -   -   -   -   -   -   - \n"
    end
    puts "\n\n\n"
  end

  def place_starting_pieces
    @board[0][1] = Pawn.new('white')
    @board[1][1] = Pawn.new('white')
    @board[2][1] = Pawn.new('white')
    @board[3][1] = Pawn.new('white')
    @board[4][1] = Pawn.new('white')
    @board[5][1] = Pawn.new('white')
    @board[6][1] = Pawn.new('white')
    @board[7][1] = Pawn.new('white')
    @board[0][0] = Rook.new('white')
    @board[7][0] = Rook.new('white')
    @board[1][0] = Knight.new('white')
    @board[6][0] = Knight.new('white')
    @board[2][0] = Bishop.new('white')
    @board[5][0] = Bishop.new('white')
    @board[3][0] = Queen.new('white')
    @board[4][0] = King.new('white')

    @board[0][6] = Pawn.new('black')
    @board[1][6] = Pawn.new('black')
    @board[2][6] = Pawn.new('black')
    @board[3][6] = Pawn.new('black')
    @board[4][6] = Pawn.new('black')
    @board[5][6] = Pawn.new('black')
    @board[6][6] = Pawn.new('black')
    @board[7][6] = Pawn.new('black')
    @board[0][7] = Rook.new('black')
    @board[7][7] = Rook.new('black')
    @board[1][7] = Knight.new('black')
    @board[6][7] = Knight.new('black')
    @board[2][7] = Bishop.new('black')
    @board[5][7] = Bishop.new('black')
    @board[3][7] = Queen.new('black')
    @board[4][7] = King.new('black')
  end
end

board = Board.new
board.display_board