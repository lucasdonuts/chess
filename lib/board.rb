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
    @passant_opening = nil
    place_starting_pieces
  end

  def display_board
    print "\n\n\n                 a   b   c   d   e   f   g   h \n"
    puts '                 -   -   -   -   -   -   -   - '
    7.downto(0) do |x|
      print "             #{x + 1} | "
      0.upto(7) do |y|
        print @board[y][x].nil? ? '  | ' : "#{@board[y][x].symbol} | "
      end
      print (x + 1).to_s
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
      'empty'
    elsif @board[coords[0]][coords[1]].color == player_color
      'friendly'
    else
      'enemy'
    end
  end

  def king_in_check?(color)
    king = color == :white ? @white_king : @black_king
    get_enemy_list(color).each do |enemy|
      return true if enemy.get_moves(self).include?(king.location)
    end
    false
    # get_enemy_moves(color).include?(king.location)
  end

  def square_under_attack?(coords, color)
    get_enemy_list(color).each do |enemy|
      return true if enemy.get_moves(self).include?(coords)
    end
    false
  end

  def test_causes_check?(piece, destination)
    test_board = TestBoard.new(@board)
    test_board.white_king = @white_king.dup
    test_board.black_king = @black_king.dup
    location = piece.location
    target_piece = test_board.board[location[0]][location[1]].dup
    test_board.move_piece(target_piece, destination)
    test_board.king_in_check?(piece.color)
  end

  def causes_check?(piece, destination) # Trash trash trash wtf
    check = false
    first_move = piece.first_move
    passant = @passant_pawn.dup.dup
    board_copy = Board.new
    board_copy.board = @board.dup.map(&:dup)
    board_copy.passant_pawn = passant
    board_copy.white_king = @board[@white_king.location[0]][@white_king.location[1]]
    board_copy.black_king = @board[@black_king.location[0]][@black_king.location[1]]
    original_location = piece.location
    piece_copy = board_copy.board[original_location[0]][original_location[1]]
    board_copy.move_piece(piece_copy, destination)
    check = true if board_copy.king_in_check?(piece_copy.color)
    piece.location = original_location
    piece.first_move = first_move
    @passant_pawn = passant
    check
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
    get_enemy_list(color).each { |enemy| enemy_moves += enemy.get_moves(self) }
    enemy_moves
  end

  def can_castle_left?(king)
    return false unless king.first_move

    case king.color
    when :white
      return false unless @left_white_rook.first_move

      check_square([3, 0], :white) == 'empty' &&
        check_square([2, 0], :white) == 'empty' &&
        check_square([1, 0], :white) == 'empty' &&
        !causes_check?(king, [3, 0]) &&
        !causes_check?(king, [2, 0])
    when :black
      return false unless @left_black_rook.first_move

      check_square([3, 7], :black) == 'empty' &&
        check_square([2, 7], :black) == 'empty' &&
        check_square([1, 7], :black) == 'empty' &&
        !causes_check?(king, [3, 7]) &&
        !causes_check?(king, [2, 7])
    end
  end

  def can_castle_right?(king)
    return false unless king.first_move

    case king.color
    when :white
      return false unless @right_white_rook.first_move

      check_square([5, 0], :white) == 'empty' &&
        check_square([6, 0], :white) == 'empty' &&
        !causes_check?(king, [5, 0]) &&
        !causes_check?(king, [6, 0])
    when :black
      return false unless @right_black_rook.first_move

      check_square([5, 7], :black) == 'empty' &&
        check_square([6, 7], :black) == 'empty' &&
        !causes_check?(king, [5, 7]) &&
        !causes_check?(king, [6, 7])
    end
  end

  def castle_check(piece, destination)
    return unless piece.instance_of?(King)

    if destination[0] == piece.location[0] + 2
      castle_right(piece.color)
      nil
    elsif destination[0] == piece.location[0] - 2
      castle_left(piece.color)
      nil
    end
  end

  def castle_left(color)
    if color == :white
      move_piece(@left_white_rook, [3, 0])
    else
      move_piece(@left_black_rook, [3, 7])
    end
  end

  def castle_right(color)
    if color == :white
      move_piece(@right_white_rook, [5, 0])
    else
      move_piece(@right_black_rook, [5, 7])
    end
  end

  def valid_selection?(coords, player_color)
    case check_square(coords, player_color)
    when 'empty'
      puts "\nThere is no piece there."
      false
    when 'enemy'
      puts "\nThat is not your piece."
      false
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

  # def passant_check(piece, destination)
  #   p piece.location
  #   p destination
  #   if piece.symbol == '♙' && piece.location[1] - 2 == destination[1]
  #     # If a black pawn wants to move 2 squares forward
  #     # set passant_pawn to an invisible 'ghost' copy of pawn
  #     p "Black passant opening"
  #     @passant_pawn = Pawn.new(:black, [destination[0], destination[1] + 1])
  #     @passant_pawn.symbol = " "
  #     # place ghost pawn on board
  #     @board[@passant_pawn.location[0]][@passant_pawn.location[1]] = @passant_pawn
  #   elsif piece.symbol == '♟' && piece.location[1] + 2 == destination[1]
  #     # if a white pawn wants to move 2 squares forward
  #     # set passant_pawn to an invisible 'ghost' copy of pawn
  #     p "White passant opening"
  #     @passant_pawn = Pawn.new(:white, [destination[0], destination[1] - 1])
  #     @passant_pawn.symbol = " "
  #     # place ghost pawn on board
  #     @board[@passant_pawn.location[0]][@passant_pawn.location[1]] = @passant_pawn
  #   elsif passant_capture?(destination, piece.color)
  #     p "Passant capture"
  #     if piece.color == :white
  #       # remove captured piece
  #       @board[destination[0]][destination[1] - 1] = nil
  #     else
  #       @board[destination[0]][destination[1] + 1] = nil
  #     end
  #     # remove ghost from board and set passant_pawn to nil
  #     @board[@passant_pawn.location[0]][@passant_pawn.location[1]] = nil
  #     @passant_pawn = nil
  #   else
  #     # if not performing en passant,
  #     # remove ghost from board and set passant_pawn to nil
  #     if !@passant_pawn.nil?
  #       @board[@passant_pawn.location[0]][@passant_pawn.location[1]] = nil
  #       @passant_pawn = nil
  #     end
  #   end
  # end

  def passant_capture?(destination)
    destination == @passant_opening
  end

  # def passant_capture?(destination, piece_color)
  #   # true if there is a passant opening and enemy is moving into it
  #   !@passant_pawn.nil? &&
  #   destination == @passant_pawn.location &&
  #   @passant_pawn.color != piece_color
  # end

  def promotion?(piece)
    if piece.color == :white
      return true if piece.location[1] == 7
    else
      return true if piece.location[1] == 0
    end
    false
  end

  def promote_pawn(pawn)
    puts 'You can change it to a queen, rook, knight, or bishop'
    puts 'Which would you like to promote it to?'
    choice = gets.chomp.downcase
    case choice
    when 'queen'
      @board[pawn.location[0]][pawn.location[1]] = Queen.new(pawn.color, pawn.location)
    when 'rook'
      @board[pawn.location[0]][pawn.location[1]] = Rook.new(pawn.color, pawn.location)
    when 'knight'
      @board[pawn.location[0]][pawn.location[1]] = Knight.new(pawn.color, pawn.location)
    when 'bishop'
      @board[pawn.location[0]][pawn.location[1]] = Bishop.new(pawn.color, pawn.location)
    else
      puts 'Invalid input.'
      promote_pawn(pawn)
    end
  end

  def promotion_check(piece)
    return false if !piece.instance_of?(Pawn) || !promotion?(piece)

    puts 'Your pawn has been promoted!'
    promote_pawn(piece)
  end

  def capture_check(_piece, destination)
    return if @board[destination[0]][destination[1]].nil?

    @board[destination[0]][destination[1]].location = nil
  end

  def move_piece(piece, destination)
    case move_type(piece, destination)
    when 'pawn 2'
      move_pawn_2(piece, destination)
      p "Passant opening: #{@passant_opening}"
    when 'passant capture'
      en_passant_move(piece, destination)
      @passant_opening = nil
      p 'Passant capture'
    when 'rook'
      @passant_opening = nil
      rook_move(piece, destination)
      p 'Rook move'
    when 'king'
      @passant_opening = nil
      king_move(piece, destination)
      p 'King move'
    else
      @passant_opening = nil
      standard_move(piece, destination)
      p "Standard move: #{piece.location}"
    end
  end

  def move_type(piece, destination)
    return 'passant capture' if passant_capture?(destination)

    case piece
    when Pawn
      if passant_vulnerable?(piece, destination)
        'pawn 2'
      else
        'standard'
      end
    when King
      return 'king'
      p 'King'
    when Rook
      return 'rook'
      p 'Rook'
    else
      return 'standard'
      p 'Other'
    end
  end

  def can_castle_left?(king)
    return false unless king.first_move

    case king.color
    when :white
      return false unless @white_left_castle

      check_square([3, 0], :white) == 'empty' &&
        check_square([2, 0], :white) == 'empty' &&
        check_square([1, 0], :white) == 'empty' &&
        !get_enemy_moves(:white).include?([3, 0]) &&
        !get_enemy_moves(:white).include?([2, 0])

    when :black
      return false unless @black_left_castle

      check_square([3, 7], :black) == 'empty' &&
        check_square([2, 7], :black) == 'empty' &&
        check_square([1, 7], :black) == 'empty' &&
        !get_enemy_moves(:black).include?([3, 7]) &&
        !get_enemy_moves(:black).include?([2, 7])
    end
  end

  def can_castle_right?(king)
    return false unless king.first_move

    case king.color
    when :white
      return false unless @white_right_castle

      check_square([5, 0], :white) == 'empty' &&
        check_square([6, 0], :white) == 'empty' &&
        !get_enemy_moves(:white).include?([5, 0]) &&
        !get_enemy_moves(:white).include?([6, 0])
    when :black
      return false unless @black_right_castle

      check_square([5, 7], :black) == 'empty' &&
        check_square([6, 7], :black) == 'empty' &&
        !get_enemy_moves(:black).include?([5, 7]) &&
        !get_enemy_moves(:black).include?([6, 7])
    end
  end

  def king_move(king, destination)
    if left_castle?(destination)
      if @white_left_castle && king.color == :white
        p 'Left white castle'
        castle_left(king)
      elsif @black_left_castle && king.color == :black
        p 'Left black castle'
        castle_left(king)
      else
        p 'Standard king move'
        standard_move(king, destination)
      end
    elsif right_castle?(destination)
      if @white_right_castle && king.color == :white
        p 'White right castle'
        castle_right(king)
        king.first_move = false
      elsif @black_right_castle && king.color == :black
        p 'Black right castle'
        castle_right(king)
        king.first_move = false
      else
        p 'Standard king move'
        standard_move(king, destination)
        king.first_move = false
      end
    else
      p 'Standard king move'
      standard_move(king, destination)
      king.first_move = false
    end
  end

  def passant_vulnerable?(piece, destination)
    if piece.color == :white && piece.first_move
      piece.location[1] == 1 && destination[1] == 3
    elsif piece.color == :black && piece.first_move
      piece.location[1] == 6 && destination[1] == 4
    else
      false
    end
  end

  def passant_capture?(destination)
    destination == @passant_opening
  end

  def left_castle?(destination)
    destination[0] == 2
  end

  def castle_left(king)
    case king.color
    when :white
      @board[2][0] = king
      @board[4][0] = nil
      @board[3][0] = @board[0][0]
      @board[0][0] = nil
      @board[3][0].location = [3, 0]
    when :black
      @board[2][7] = king
      @board[4][7] = nil
      @board[3][7] = @board[0][7]
      @board[0][7] = nil
      @board[3][7].location = [3, 7]
    end
    king.location[0] = king.color == :white ? @white_left_castle = false : @black_left_castle = false
  end

  def right_castle?(destination)
    destination[0] == 6
  end

  def castle_right(king)
    case king.color
    when :white
      @board[6][0] = king
      @board[4][0] = nil
      @board[5][0] = @board[7][0]
      @board[7][0] = nil
      @board[5][0].location = [5, 0]
    when :black
      @board[6][7] = king
      @board[4][7] = nil
      @board[5][7] = @board[7][7]
      @board[7][7] = nil
      @board[5][7].location = [5, 7]
    end
    king.location[0] = 6
    king.color == :white ? @white_right_castle = false : @black_right_castle = false
  end

  def rook_move(rook, destination)
    if rook.side == :left
      rook.color == :white ? @white_left_castle = false : @black_left_castle = false
    else
      rook.color == :white ? @white_right_castle = false : @black_left_castle = false
    end
    @board[destination[0]][destination[1]] = rook
    @board[rook.location[0]][rook.location[1]] = nil
    rook.location = destination
  end

  def move_pawn_2(pawn, destination)
    @passant_opening = pawn.color == :white ? [destination[0], destination[1] - 1] : [destination[0], destination[1] + 1]
    @board[destination[0]][destination[1]] = pawn
    @board[pawn.location[0]][pawn.location[1]] = nil
    pawn.first_move = false
    pawn.location = destination
  end

  def standard_move(piece, destination)
    @board[destination[0]][destination[1]] = piece
    @board[piece.location[0]][piece.location[1]] = nil
    piece.location = destination
  end

  def en_passant_move(piece, destination)
    case piece.color
    when :white
      @board[destination[0]][destination[1] + 1] = nil
    when :black
      @board[destination[0]][destination[1] - 1] = nil
    end
    @board[destination[0]][destination[1]] = piece
    @board[piece.location[0]][piece.location[1]] = nil
    piece.location = destination
  end

  # def move_piece(piece, destination)
  #   # p "Passant: #{@passant_pawn}"
  #   # passant_check(piece, destination)
  #   # p "Passant after: #{@passant_pawn}"
  #   castle_check(piece, destination)
  #   capture_check(piece, destination)
  #   from = piece.location
  #   self.board[from[0]][from[1]] = nil
  #   self.board[destination[0]][destination[1]] = piece
  #   piece.location = destination
  #   if piece.kind_of?(Pawn) || piece.kind_of?(Rook) || piece.kind_of?(King)
  #     piece.first_move = false
  #   end
  #   promotion_check(piece)
  # end

  def get_moves(piece)
    moves = piece.get_moves(self)
    moves.delete_if { |move| test_causes_check?(piece, move) }
    # moves.delete_if {|move| causes_check?(piece, move) }
  end

  def check_mate?(player_color)
    player_color == :white ? @white_king.location.nil? : @black_king.location.nil?
  end
end

def trash
  # def in_bounds?(move)
  #   (1..8).include?(move[0]) && (1..8).include?(move[1])
  # end

  # def square_empty?(square)
  #   @board[square[0]][square[1]].nil?
  # end

  # def current_players_piece?(piece, player_color)
  #   piece.color == player_color
  # end

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
