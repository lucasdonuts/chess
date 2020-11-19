require_relative 'pieces/piece.rb'
require_relative 'pieces/pawn.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/queen.rb'
require_relative 'pieces/king.rb'

class Board
  attr_reader :board
  attr_accessor :passant_pawn

  def initialize
    @board = Array.new(8) { Array.new(8) }
    @passant_pawn = nil
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

  def current_players_piece?(piece, player_color)
    piece.color == player_color
  end

  def valid_selection?(coords, player_color)
    if square_empty?(coords)
      puts "\nThere is no piece there."
      return false
    elsif !current_players_piece?(@board[coords[0]][coords[1]], player_color)
      puts "\nThat is not your piece."
      return false
    else
      true
    end
  end

  def valid_destination?(piece, destination)
    moves = piece.get_moves(self)
    moves.include?(destination)
  end

  def passant_check(piece, destination)
    if piece.symbol == '♙' && piece.location[1] - 2 == destination[1]
      # If a black pawn wants to move 2 squares forward
      @passant_pawn = Pawn.new(:white, [destination[0], destination[1] + 1])
      @passant_pawn.symbol = " "
    elsif piece.symbol == '♟' && piece.location[1] + 2 == destination[1]
      # if a white pawn wants to move 2 squares forward
      @passant_pawn = Pawn.new(:white, [destination[0], destination[1] - 1])
      @passant_pawn.symbol = " "
    elsif passant_capture?(destination)
      if piece.color == :white
        @board[destination[0]][destination[1] - 1] = nil
      else
        @board[destination[0]][destination[1] + 1] = nil
      end
      @passant_pawn = nil
    else
      @passant_pawn = nil
    end
  end

  def passant_capture?(destination)
    !@passant_pawn.nil? && destination == @passant_pawn.location
  end

  def move_piece(piece, destination)
    passant_check(piece, destination)
    from = piece.location
    @board[from[0]][from[1]] = nil
    @board[destination[0]][destination[1]] = piece
    piece.location = destination
    if piece.symbol == '♙' || piece.symbol == '♟'
      piece.first_move = false
    end
  end

  def get_moves(piece, board)
    moves = piece.get_moves(board)
  end
end

def trash

  # def path_obstructed?(piece, destination) # Possibly going to be redundant
  #   friendly_piece_locations = piece.color == :white ? get_white_positions : get_black_positions
  #   friendly_piece_locations.include?(destination)

  # end

  # def pawn_possible_captures(pawn) # Possibly redundant
  #   x = pawn.location[0]
  #   y = pawn.location[1]
  #   possible_captures = []
  #   case pawn.color
  #   when :white
  #     possible_captures << [x + 1, y + 1] unless @board[x + 1][y + 1].nil? || @board[x + 1][y + 1].color == :white
  #     possible_captures << [x - 1, y + 1] unless @board[x - 1][y + 1].nil? || @board[x - 1][y + 1].color == :white
  #   when :black
  #     possible_captures << [x + 1, y - 1] unless @board[x + 1][y - 1].nil? || @board[x + 1][y - 1].color == :black
  #     possible_captures << [x - 1, y - 1] unless @board[x - 1][y - 1].nil? || @board[x - 1][y - 1].color == :black
  #   end
  #   possible_captures
  # end


  # def get_white_positions #Possibly redundant
  #   white_positions = []

  #   8.times do |x|
  #     8.times do |y|
  #       white_positions << board[x][y].location unless board[x][y].nil? || board[x][y].color == :black
  #     end
  #   end
  #   white_positions
  # end

  # def get_black_positions #Possibly redundant
  #   black_positions = []

  #   8.times do |x|
  #     8.times do |y|
  #       black_positions << board[x][y].location unless board[x][y].nil? || board[x][y].color == :white
  #     end
  #   end
  #   black_positions
  # end
end