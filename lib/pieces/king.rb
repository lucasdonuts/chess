require_relative 'piece.rb'

class King < Piece
  attr_reader :symbol, :color
  attr_accessor :location, :first_move

  def initialize(color, location)
    @location = location
    @color = color
    @symbol = select_symbol
    @first_move = true
  end

  def select_symbol
    @color == :white ? '♚' : '♔'
  end

  def get_moves(board)
    moves = []
    x = @location[0]
    y = @location[1]

    moves << [x, y + 1] unless board.check_square([x, y + 1], @color) == 'friendly'
    moves << [x, y - 1] unless board.check_square([x, y - 1], @color) == 'friendly'
    moves << [x + 1, y] unless board.check_square([x + 1, y], @color) == 'friendly'
    moves << [x + 1, y + 1] unless board.check_square([x + 1, y + 1], @color) == 'friendly'
    moves << [x + 1, y - 1] unless board.check_square([x + 1, y - 1], @color) == 'friendly'
    moves << [x - 1, y] unless board.check_square([x - 1, y], @color) == 'friendly'
    moves << [x - 1, y + 1] unless board.check_square([x - 1, y + 1], @color) == 'friendly'
    moves << [x - 1, y - 1] unless board.check_square([x - 1, y - 1], @color) == 'friendly'

    moves += castling_moves(board)

    moves.reject! {|move| move.any? {|i| i < 0 || i > 7 }}
    moves
  end

  def castling_moves(board)
    castling_moves = []
    return [] if !board.can_castle_left?(self) and !board.can_castle_right?(self)
    x = @location[0]
    y = @location[1]
    
    castling_moves << [x - 2, y] if board.can_castle_left?(self)
    castling_moves << [x + 2, y] if board.can_castle_right?(self)
  end
end