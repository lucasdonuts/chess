require_relative 'piece.rb'

class King < Piece
  def select_symbol
    @color == :white ? '♚' : '♔'
  end

  def get_moves
    moves = []
    x = @location[0]
    y = @location[1]

    moves << [x, y + 1] unless @board.check_square([x, y + 1], @color) == 'friendly'
    moves << [x, y - 1] unless @board.check_square([x, y - 1], @color) == 'friendly'
    moves << [x + 1, y] unless @board.check_square([x + 1, y], @color) == 'friendly'
    moves << [x + 1, y + 1] unless @board.check_square([x + 1, y + 1], @color) == 'friendly'
    moves << [x + 1, y - 1] unless @board.check_square([x + 1, y - 1], @color) == 'friendly'
    moves << [x - 1, y] unless @board.check_square([x - 1, y], @color) == 'friendly'
    moves << [x - 1, y + 1] unless @board.check_square([x - 1, y + 1], @color) == 'friendly'
    moves << [x - 1, y - 1] unless @board.check_square([x - 1, y - 1], @color) == 'friendly'

    moves += castling_moves

    moves.reject! {|move| move.any? {|i| i < 0 || i > 7 }}
    moves
  end

  def castling_moves
    castling_moves = []
    return [] if !@board.can_castle_left?(self) and !@board.can_castle_right?(self)
    x = @location[0]
    y = @location[1]
    
    castling_moves << [x - 2, y] if @board.can_castle_left?(self)
    castling_moves << [x + 2, y] if @board.can_castle_right?(self)
    castling_moves
  end
end