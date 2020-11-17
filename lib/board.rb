require_relative 'pieces/piece.rb'
require_relative 'pieces/pawn.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/queen.rb'
require_relative 'pieces/king.rb'

# currently writing and testing path_obstructed? method, currently only checks destination

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
    (0..7).each do |x|
      @board[x][1] = Pawn.new(:white, [x, 1])
      @board[x][6] = Pawn.new(:black, [x, 6])
    end
    @board[0][0] = Rook.new(:white, [0, 0])
    @board[7][0] = Rook.new(:white, [7, 0])
    @board[1][0] = Knight.new(:white, [1, 0])
    @board[6][0] = Knight.new(:white, [6, 0])
    @board[2][0] = Bishop.new(:white, [2, 0])
    @board[5][0] = Bishop.new(:white, [5, 0])
    @board[3][0] = Queen.new(:white, [3, 0])
    @board[4][0] = King.new(:white, [4, 0])

    @board[0][7] = Rook.new(:black, [0, 7])
    @board[7][7] = Rook.new(:black, [7, 7])
    @board[1][7] = Knight.new(:black, [1, 7])
    @board[6][7] = Knight.new(:black, [6, 7])
    @board[2][7] = Bishop.new(:black, [2, 7])
    @board[5][7] = Bishop.new(:black, [5, 7])
    @board[3][7] = Queen.new(:black, [3, 7])
    @board[4][7] = King.new(:black, [4, 7])
  end

  def current_players_piece?(piece, current_player)
    piece.color == current_player.color
  end

  def get_white_positions
    white_positions = []

    8.times do |x|
      8.times do |y|
        white_positions << board[x][y].location unless board[x][y].nil? || board[x][y].color == :black
      end
    end
    white_positions
  end

  def get_black_positions
    black_positions = []

    8.times do |x|
      8.times do |y|
        black_positions << board[x][y].location unless board[x][y].nil? || board[x][y].color == :white
      end
    end
    black_positions
  end

  def get_moves(piece, board)
    moves = piece.get_moves(board)
  end

  def path_obstructed?(piece, destination)
    friendly_piece_locations = piece.color == :white ? get_white_positions : get_black_positions
    friendly_piece_locations.include?(destination)

  end

  def pawn_possible_captures(pawn)
    x = pawn.location[0]
    y = pawn.location[1]
    possible_captures = []
    case pawn.color
    when :white
      possible_captures << [x + 1, y + 1] unless @board[x + 1][y + 1].nil? || @board[x + 1][y + 1].color == :white
      possible_captures << [x - 1, y + 1] unless @board[x - 1][y + 1].nil? || @board[x - 1][y + 1].color == :white
    when :black
      possible_captures << [x + 1, y - 1] unless @board[x + 1][y - 1].nil? || @board[x + 1][y - 1].color == :black
      possible_captures << [x - 1, y - 1] unless @board[x - 1][y - 1].nil? || @board[x - 1][y - 1].color == :black
    end
    possible_captures
  end
end

board = Board.new
pawn = board.board[3][1]
board.board[2][2] = Pawn.new(:black, [2, 2])
board.board[4][2] = Pawn.new(:black, [4, 2])
pawn.get_captures(board)
# board.display_board
# p board.pawn_possible_captures(board.board[3][1])
# p board.path_obstructed?(board.board[0][1], [0, 2])
# board.board[2][2] = Pawn.new(:black, [2, 2])
# board.display_board
# p board.pawn_possible_captures(board.board[3][1])