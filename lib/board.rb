require_relative 'pieces/piece.rb'
require_relative 'pieces/pawn.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/queen.rb'
require_relative 'pieces/king.rb'

class Board
  attr_accessor :left_white_rook,
                :left_black_rook,
                :right_white_rook,
                :right_black_rook,
                :white_king,
                :black_king,
                :board,
                :passant_opening

  def initialize
    @board = Array.new(8) { Array.new(8) }
    @passant_opening = nil
    place_starting_pieces
    @white_left_castle = true
    @black_left_castle = true
    @white_right_castle = true
    @black_right_castle = true
  end
  
  def black_king
    @board.each do |row|
      row.each do |square|
        if square.is_a?(King) && square.color == :black
          return square
        else
          next
        end
      end
    end
    return
  end

  def can_castle_left?(king)
    case king.color
    when :white
      return false unless @white_left_castle

      check_square([3, 0], :white) == 'empty' &&
      check_square([2, 0], :white) == 'empty' &&
      check_square([1, 0], :white) == 'empty' &&
      !square_under_attack?([3, 0], :white) &&
      !square_under_attack?([2, 0], :white)

    when :black
      return false unless @black_left_castle

      check_square([3, 7], :black) == 'empty' &&
      check_square([2, 7], :black) == 'empty' &&
      check_square([1, 7], :black) == 'empty' &&
      !square_under_attack?([3, 7], :black) &&
      !square_under_attack?([2, 7], :black)
    end
  end

  def can_castle_right?(king)
    case king.color
    when :white
      return false unless @white_right_castle

      check_square([5, 0], :white) == 'empty' &&
        check_square([6, 0], :white) == 'empty' &&
        !square_under_attack?([5, 0], :white) &&
        !square_under_attack?([6, 0], :white)
    when :black
      return false unless @black_right_castle

      check_square([5, 7], :black) == 'empty' &&
        check_square([6, 7], :black) == 'empty' &&
        !square_under_attack?([5, 7], :black) &&
        !square_under_attack?([6, 7], :black)
    end
  end

  def capture_check(piece, destination) # Possibly obsolete
    return if @board[destination[0]][destination[1]].nil?

    @board[destination[0]][destination[1]].location = nil
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
    king.location[0] = 2
    king.color == :white ? @white_left_castle = false : @black_left_castle = false
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

  # def causes_check?(piece, destination)
  #   copy = FakeBoard.new(@passant_opening, @white_left_castle, @black_left_castle, @white_right_castle, @black_right_castle)
  #   (0..7).each do |x|
  #     (0..7).each do |y|
  #       square = @board[x][y]
  #       if square.nil?
  #         copy.board[x][y] = square
  #       else
  #         copy.board[x][y] = square.class.new(square.color, square.location, copy)
  #       end
  #     end
  #   end
  #   copy.move_piece(copy.board[piece.location[0]][piece.location[1]], destination)
  #   p "King in check?: "
  #   p copy.king_in_check?(piece.color)
  # end

  def causes_check?(piece, destination)
    test_move(piece, destination)
  end

  def checkmate?(current_player_color)
    current_player_color == :white ? white_king.nil? : black_king.nil?
  end

  def check_square(coords, player_color)
    if coords == @passant_opening
      return 'en passant'
    elsif @board[coords[0]][coords[1]].nil?
      return 'empty'
    elsif @board[coords[0]][coords[1]].color == player_color
      return 'friendly'
    else
      return 'enemy'
    end
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

  def en_passant_capture(piece, destination)
    case piece.color
    when :white
      @board[destination[0]][destination[1] - 1] = nil
    when :black
      @board[destination[0]][destination[1] + 1] = nil
    end
    @board[destination[0]][destination[1]] = piece
    @board[piece.location[0]][piece.location[1]] = nil
    piece.location = destination
  end

  def find_king(color)
    color == :white ? white_king : black_king
  end

  def get_enemy_list(color)
    enemy_positions = []

    8.times do |x|
      8.times do |y|
        enemy_positions << [x, y] unless board[x][y].nil? || board[x][y].color == color
      end
    end
    enemy_positions
  end

  def get_moves(piece)
    moves = piece.get_moves
    moves.delete_if {|move| causes_check?(piece, move) }
  end

  def king_in_check?(color)
    king = find_king(color)
    return false if king.nil?
    get_enemy_list(color).each do |enemy|
      return true if @board[enemy[0]][enemy[1]].get_moves.include?(king.location)
    end
    false
  end

  def king_move(king, destination)
    if left_castle?(destination)
      if @white_left_castle && king.color == :white
        castle_left(king)
      elsif @black_left_castle && king.color == :black
        castle_left(king)
      else
        standard_move(king, destination)
      end
    elsif right_castle?(destination)
      if @white_right_castle && king.color == :white
        castle_right(king)
        #king.first_move = false
      elsif @black_right_castle && king.color == :black
        castle_right(king)
        #king.first_move = false
      else
        standard_move(king, destination)
        #king.first_move = false
      end
    else
      standard_move(king, destination)
      #king.first_move = false
    end
    if king.color == :white
      @white_right_castle = false
      @white_left_castle = false
    elsif king.color == :black
      @black_right_castle = false
      @black_left_castle = false
    end
  end

  def left_castle?(destination)
    destination[0] == 2
  end

  def move_pawn_2(pawn, destination)
    @passant_opening = pawn.color == :white ? [destination[0], destination[1] - 1] : [destination[0], destination[1] + 1]
    @board[destination[0]][destination[1]] = pawn
    @board[pawn.location[0]][pawn.location[1]] = nil
    #pawn.first_move = false
    pawn.location = destination
  end

  def move_piece(piece, destination)
    case move_type(piece, destination)
    when 'promotion'
      standard_move(piece, destination)
      promote_pawn(piece)
    when 'pawn 2'
      move_pawn_2(piece, destination)
    when 'passant capture'
      en_passant_capture(piece, destination)
      @passant_opening = nil
    when 'rook'
      @passant_opening = nil
      rook_move(piece, destination)
    when 'king'
      @passant_opening = nil
      king_move(piece, destination)
    else
      @passant_opening = nil
      standard_move(piece, destination)
    end
    piece.first_move = false
  end

  def move_type(piece, destination)
    return 'passant capture' if passant_capture?(destination)

    case piece
    when Pawn
      if passant_vulnerable?(piece, destination)
        return 'pawn 2'
      elsif promotion?(piece, destination)
        return 'promotion'
      else
        return 'standard'
      end
    when King
      return 'king'
    when Rook
      return 'rook'
    else
      return 'standard'
    end
  end

  def no_moves?(coords)
    get_moves(@board[coords[0]][coords[1]]).empty?
  end

  def passant_capture?(destination)
    destination == @passant_opening
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

  def place_starting_pieces
    (0..7).each do |x|
      @board[x][1] = Pawn.new(:white, [x, 1], self)
      @board[x][6] = Pawn.new(:black, [x, 6], self)
    end
    @board[0][0] = Rook.new(:white, [0, 0], self)
    @board[7][0] = Rook.new(:white, [7, 0], self)
    @board[1][0] = Knight.new(:white, [1, 0], self)
    @board[6][0] = Knight.new(:white, [6, 0], self)
    @board[2][0] = Bishop.new(:white, [2, 0], self)
    @board[5][0] = Bishop.new(:white, [5, 0], self)
    @board[3][0] = Queen.new(:white, [3, 0], self)
    @board[4][0] = King.new(:white, [4, 0], self)

    @board[0][7] = Rook.new(:black, [0, 7], self)
    @board[7][7] = Rook.new(:black, [7, 7], self)
    @board[1][7] = Knight.new(:black, [1, 7], self)
    @board[6][7] = Knight.new(:black, [6, 7], self)
    @board[2][7] = Bishop.new(:black, [2, 7], self)
    @board[5][7] = Bishop.new(:black, [5, 7], self)
    @board[3][7] = Queen.new(:black, [3, 7], self)
    @board[4][7] = King.new(:black, [4, 7], self)

    @left_white_rook = @board[0][0]
    @right_white_rook = @board[7][0]
    @left_black_rook = @board[0][7]
    @right_black_rook = @board[7][7]

    #@white_king = @board[4][0]
    #@black_king = @board[4][7]
  end

  def promote_pawn(pawn)
    display_board
    puts "\n\n\n           Your pawn has been promoted!"
    puts "           You can change it to a queen, rook, knight, or bishop"
    puts "           Which would you like to promote it to?"
    choice = gets.chomp.downcase
    case choice
    when 'queen'
      @board[pawn.location[0]][pawn.location[1]] = Queen.new(pawn.color, pawn.location, self)
    when 'rook'
      @board[pawn.location[0]][pawn.location[1]] = Rook.new(pawn.color, pawn.location, self)
    when 'knight'
      @board[pawn.location[0]][pawn.location[1]] = Knight.new(pawn.color, pawn.location, self)
    when 'bishop'
      @board[pawn.location[0]][pawn.location[1]] = Bishop.new(pawn.color, pawn.location, self)
    else
      puts 'Invalid input.'
      promote_pawn(pawn)
    end
  end

  def promotion?(pawn, destination)
    if pawn.color == :white
      return destination[1] == 7
    elsif pawn.color == :black
      return destination[1] == 0
    end
  end

  def right_castle?(destination)
    destination[0] == 6
  end

  def rook_move(rook, destination)
    if rook.side == :left
      rook.color == :white ? @white_left_castle = false : @black_left_castle = false
    else
      rook.color == :white ? @white_right_castle = false : @black_right_castle = false
    end
    @board[destination[0]][destination[1]] = rook
    @board[rook.location[0]][rook.location[1]] = nil
    rook.location = destination
  end

  def square_under_attack?(coords, color)
    get_enemy_list(color).each do |enemy|
      return true if @board[enemy[0]][enemy[1]].get_moves.include?(coords)
    end
    false
  end

  def standard_move(piece, destination)
    @board[destination[0]][destination[1]] = piece
    @board[piece.location[0]][piece.location[1]] = nil
    piece.location = destination
  end

  def test_move(piece, destination)
    old_location = piece.location
    if destination == @passant_opening
      captured = @passant_opening[1] == 2 ? @board[destination[0]][destination[1] + 1] :
                                          @board[destination[0]][destination[1] - 1]
    else
      captured = @board[destination[0]][destination[1]]
    end
    @board[destination[0]][destination[1]] = piece
    @board[piece.location[0]][piece.location[1]] = nil
    piece.location = destination
    if king_in_check?(piece.color)
      undo_test_move(old_location, captured, piece, destination)
      check = true
    else
      undo_test_move(old_location, captured, piece, destination)
      check = false
    end
    check
  end

  def undo_test_move(old_location, captured, piece, destination)
    @board[old_location[0]][old_location[1]] = piece
    piece.location = old_location
    @board[destination[0]][destination[1]] = nil
    @board[captured.location[0]][captured.location[1]] = captured unless captured.nil?
  end

  def valid_destination?(piece, destination)
    moves = get_moves(piece)
    moves.include?(destination)
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

  def white_king
    @board.each do |row|
      row.each do |square|
        if square.is_a?(King) && square.color == :white
          return square
        else
          next
        end
      end
    end
    return
  end
end

class FakeBoard < Board
  def initialize(po, wlc, blc, wrc, brc)
    @board = Array.new(8) { Array.new(8) }
    @passant_opening = po
    @white_left_castle = wlc
    @black_left_castle = blc
    @white_right_castle = wrc
    @black_right_castle = brc
  end

  def move_piece(piece, destination)
    case move_type(piece, destination)
    when 'promotion'
      standard_move(piece, destination)
    when 'pawn 2'
      move_pawn_2(piece, destination)
    when 'passant capture'
      en_passant_capture(piece, destination)
      @passant_opening = nil
    when 'rook'
      @passant_opening = nil
      rook_move(piece, destination)
    when 'king'
      @passant_opening = nil
      king_move(piece, destination)
    else
      @passant_opening = nil
      standard_move(piece, destination)
    end
    piece.first_move = false
  end
end

# board = Board.new
# board.board[7][3] = Bishop.new(:black, [7, 3], board)
# # p board.board[5][1].location
# board.causes_check?(board.board[5][1], [5, 2])


def trash
  # copy.board = @board.map {|i| i.map(&:dup)}
  # # copy_piece = copy.board[piece.location[0]][piece.location[1]]
  # copy_bishop = copy.board[7][3]
  # p copy_bishop.get_moves
  # copy.display_board
  # copy.move_piece(copy_piece, destination)
  # p copy.board[5][1]
  # copy.display_board
  # p copy_bishop.get_moves
  # p copy_piece.color
  # p "King in check?"
  # p copy.king_in_check?(copy_piece.color)

  # def check_mate?(player_color)
  #   player_color == :white ? @black_king.nil? : @white_king.nil?
  # end

  # def king_in_check?(color)
  #   king = color == :white ? @white_king : @black_king
  #   get_enemy_list(color).each do |enemy|
  #     return true if @board[enemy[0]][enemy[1]].get_moves.include?(king.location)
  #   end
  #   false
  # end

  # def promotion_check(piece) # Probably obsolete after pawn move refactoring
  #   return false if !piece.instance_of?(Pawn) || !promotion?(piece)

  #   promote_pawn(piece)
  # end

  # def get_enemy_moves(color) # Possibly obsolete
  #   enemy_moves = []
  #   get_enemy_list(color).each { |enemy| enemy_moves += enemy.get_moves }
  #   enemy_moves
  # end

  # def square_under_attack?(coords, color)
  #   get_enemy_list(color).each do |enemy|
  #     return true if enemy.get_moves.include?(coords)
  #   end
  #   false
  # end

  # def get_enemy_list(color)
  #   enemy_positions = []

  #   8.times do |x|
  #     8.times do |y|
  #       enemy_positions << board[x][y] unless board[x][y].nil? || board[x][y].color == color
  #     end
  #   end
  #   enemy_positions
  # end

  # def causes_check?(piece, destination) # Trash trash trash wtf
  #   check = false
  #   first_move = piece.first_move
  #   passant = @passant_pawn.dup.dup
  #   board_copy = Board.new
  #   board_copy.board = @board.dup.map(&:dup)
  #   board_copy.passant_pawn = passant
  #   board_copy.white_king = @board[@white_king.location[0]][@white_king.location[1]]
  #   board_copy.black_king = @board[@black_king.location[0]][@black_king.location[1]]
  #   original_location = piece.location
  #   piece_copy = board_copy.board[original_location[0]][original_location[1]]
  #   board_copy.move_piece(piece_copy, destination)
  #   check = true if board_copy.king_in_check?(piece_copy.color)
  #   piece.location = original_location
  #   piece.first_move = first_move
  #   @passant_pawn = passant
  #   check
  # end

  # def castle_left(color)
  #   if color == :white
  #     move_piece(@left_white_rook, [3, 0])
  #   else
  #     move_piece(@left_black_rook, [3, 7])
  #   end
  # end

  # def castle_right(color)
  #   if color == :white
  #     move_piece(@right_white_rook, [5, 0])
  #   else
  #     move_piece(@right_black_rook, [5, 7])
  #   end
  # end

  # def castle_check(piece, destination)
  #   return unless piece.instance_of?(King)

  #   if destination[0] == piece.location[0] + 2
  #     castle_right(piece.color)
  #     nil
  #   elsif destination[0] == piece.location[0] - 2
  #     castle_left(piece.color)
  #     nil
  #   end
  # end

  # def test_causes_check?(piece, destination)
  #   test_board = TestBoard.new(@board)
  #   test_board.white_king = @white_king.dup
  #   test_board.black_king = @black_king.dup
  #   location = piece.location
  #   target_piece = test_board.board[location[0]][location[1]].dup
  #   test_board.move_piece(target_piece, destination)
  #   test_board.king_in_check?(piece.color)
  # end

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

  # def passant_capture?(destination, piece_color)
  #   # true if there is a passant opening and enemy is moving into it
  #   !@passant_pawn.nil? &&
  #   destination == @passant_pawn.location &&
  #   @passant_pawn.color != piece_color
  # end

  # def can_castle_left?(king)
  #   return false unless king.first_move

  #   case king.color
  #   when :white
  #     return false unless @left_white_rook.first_move

  #     check_square([3, 0], :white) == 'empty' &&
  #       check_square([2, 0], :white) == 'empty' &&
  #       check_square([1, 0], :white) == 'empty' &&
  #       !causes_check?(king, [3, 0]) &&
  #       !causes_check?(king, [2, 0])
  #   when :black
  #     return false unless @left_black_rook.first_move

  #     check_square([3, 7], :black) == 'empty' &&
  #       check_square([2, 7], :black) == 'empty' &&
  #       check_square([1, 7], :black) == 'empty' &&
  #       !causes_check?(king, [3, 7]) &&
  #       !causes_check?(king, [2, 7])
  #   end
  # end

  # def can_castle_right?(king)
  #   return false unless king.first_move

  #   case king.color
  #   when :white
  #     return false unless @right_white_rook.first_move

  #     check_square([5, 0], :white) == 'empty' &&
  #       check_square([6, 0], :white) == 'empty' &&
  #       !causes_check?(king, [5, 0]) &&
  #       !causes_check?(king, [6, 0])
  #   when :black
  #     return false unless @right_black_rook.first_move

  #     check_square([5, 7], :black) == 'empty' &&
  #       check_square([6, 7], :black) == 'empty' &&
  #       !causes_check?(king, [5, 7]) &&
  #       !causes_check?(king, [6, 7])
  #   end
  # end
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