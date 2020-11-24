require_relative 'pieces/piece.rb'
require_relative 'pieces/pawn.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/queen.rb'
require_relative 'pieces/king.rb'

class Board
  attr_accessor :passant_pawn,
                :left_white_rook,
                :left_black_rook,
                :right_white_rook,
                :right_black_rook,
                :white_king,
                :black_king,
                :board

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
    column = { 0 => 'a',
               1 => 'b',
               2 => 'c',
               3 => 'd',
               4 => 'e',
               5 => 'f',
               6 => 'g',
               7 => 'h'

    }
    print "\n\n\n                 a   b   c   d   e   f   g   h \n"
    puts "                 -   -   -   -   -   -   -   - "
    7.downto(0) do |x|
      print "             #{x} | "
      0.upto(7) do |y|
        print board[y][x].nil? ? "  | " : "#{board[y][x].symbol} | "
      end
      print "#{x}"
      print "\n                 -   -   -   -   -   -   -   - \n"
    end
    print "                 a   b   c   d   e   f   g   h \n"
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

    @left_white_rook = @board[0][0]
    @right_white_rook = @board[7][0]
    @left_black_rook = @board[0][7]
    @right_black_rook = @board[7][7]

    @white_king = @board[4][0]
    @black_king = @board[4][7]
  end

  def check_square(coords, player_color)
    if @board[coords[0]][coords[1]].nil?
      return 'empty'
    elsif @board[coords[0]][coords[1]].color == player_color
      return 'friendly'
    else
      return 'enemy'
    end
  end

  def king_in_check?(color)
    king = color == :white ? @white_king : @black_king
    get_enemy_moves(color).include?(king.location)
  end

  def causes_check?(piece, destination)
    board_copy = Board.new
    original_location = piece.location
    0.upto(7) do |x|
      0.upto(7) do |y|
        board_copy.board[x][y] = @board[x][y]
      end
    end
    piece_copy = board_copy.board[piece.location[0]][piece.location[1]]
    board_copy.move_piece(piece_copy, destination)
    piece.location = original_location
    board_copy.king_in_check?(piece.color)
  end

  def get_enemy_list(color)
    enemy_positions = []

    8.times do |x|
      8.times do |y|
        enemy_positions << board[x][y] unless board[x][y].nil? || board[x][y].color == color
      end
    end
    enemy_positions
  end

  def get_enemy_moves(color)
    enemy_moves = []
    get_enemy_list(color).each {|enemy| enemy_moves += enemy.get_moves(self)}
    enemy_moves
  end

  def can_castle_left?(king)
    return false unless king.first_move
    case king.color
    when :white
      return false unless @left_white_rook.first_move
      check_square([3, 0], :white) == 'empty' &&
      check_square([2, 0], :white) == 'empty' &&
      check_square([1, 0], :white) == 'empty'
    when :black
      return false unless @left_black_rook.first_move
      check_square([3, 7], :white) == 'empty' &&
      check_square([2, 7], :white) == 'empty' &&
      check_square([1, 7], :white) == 'empty'
    end
  end

  def can_castle_right?(king)
    return false unless king.first_move
    case king.color
    when :white
      return false unless @right_white_rook.first_move
      check_square([5, 0], :white) == 'empty' &&
      check_square([6, 0], :white) == 'empty'
    when :black
      return false unless @right_black_rook.first_move
      check_square([5, 7], :white) == 'empty' &&
      check_square([6, 7], :white) == 'empty'
    end
  end

  def current_players_piece?(piece, player_color)
    piece.color == player_color
  end

  def valid_selection?(coords, player_color)
    case check_square(coords, player_color)
    when 'empty'
      puts "\nThere is no piece there."
      return false
    when 'enemy'
      puts "\nThat is not your piece."
      return false
    else
      if no_moves?(coords)
        puts "\nThat piece has no moves"
        return false
      end
      true
    end
  end

  def no_moves?(coords)
    get_moves(@board[coords[0]][coords[1]]).empty?
  end

  def valid_destination?(piece, destination)
    moves = get_moves(piece)
    moves.include?(destination)
  end

  def passant_check(piece, destination)
    if piece.symbol == '♙' && piece.location[1] - 2 == destination[1]
      # If a black pawn wants to move 2 squares forward
      # set passant_pawn to an invisible 'ghost' copy of pawn
      @passant_pawn = Pawn.new(:black, [destination[0], destination[1] + 1])
      @passant_pawn.symbol = " "
      # place ghost pawn on board
      @board[@passant_pawn.location[0]][@passant_pawn.location[1]] = @passant_pawn
    elsif piece.symbol == '♟' && piece.location[1] + 2 == destination[1]
      # if a white pawn wants to move 2 squares forward
      # set passant_pawn to an invisible 'ghost' copy of pawn
      @passant_pawn = Pawn.new(:white, [destination[0], destination[1] - 1])
      @passant_pawn.symbol = " "
      # place ghost pawn on board
      @board[@passant_pawn.location[0]][@passant_pawn.location[1]] = @passant_pawn
    elsif passant_capture?(destination, piece.color)
      if piece.color == :white
        # remove captured piece
        @board[destination[0]][destination[1] - 1] = nil
      else
        @board[destination[0]][destination[1] + 1] = nil
      end
      # remove ghost from board and set passant_pawn to nil
      @board[@passant_pawn.location[0]][@passant_pawn.location[1]] = nil
      @passant_pawn = nil
    else
      # if not performing en passant,
      # remove ghost from board and set passant_pawn to nil
      if !@passant_pawn.nil?
        @board[@passant_pawn.location[0]][@passant_pawn.location[1]] = nil
        @passant_pawn = nil
      end
    end
  end

  def passant_capture?(destination, piece_color)
    # true if there is a passant opening and enemy is moving into it
    !@passant_pawn.nil? &&
    destination == @passant_pawn.location &&
    @passant_pawn.color != piece_color
  end

  def move_piece(piece, destination)
    passant_check(piece, destination)
    from = piece.location
    @board[from[0]][from[1]] = nil
    @board[destination[0]][destination[1]] = piece
    piece.location = destination
    if piece.kind_of?(Pawn) || piece.kind_of?(Rook) || piece.kind_of?(King)
      piece.first_move = false
    end
  end

  def get_moves(piece)
    moves = piece.get_moves(self)
    moves.delete_if {|move| causes_check?(piece, move) }
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