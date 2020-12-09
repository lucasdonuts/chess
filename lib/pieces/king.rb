require_relative 'piece.rb'

class King < Piece
  def select_symbol
    @color == :white ? '♚' : '♔'
  end

  def get_moves
    moves = []
    x = @location[0]
    y = @location[1]

    moves << [x, y + 1] unless y == 7 || @board.check_square([x, y + 1], @color) == 'friendly'
    moves << [x, y - 1] unless y == 0 || @board.check_square([x, y - 1], @color) == 'friendly'
    moves << [x + 1, y] unless x == 7 || @board.check_square([x + 1, y], @color) == 'friendly'
    moves << [x + 1, y + 1] unless x == 7 || y == 7 || @board.check_square([x + 1, y + 1], @color) == 'friendly'
    moves << [x + 1, y - 1] unless x == 7 || y == 0 || @board.check_square([x + 1, y - 1], @color) == 'friendly'
    moves << [x - 1, y] unless x == 0 || @board.check_square([x - 1, y], @color) == 'friendly'
    moves << [x - 1, y + 1] unless x == 0 || y == 7 || @board.check_square([x - 1, y + 1], @color) == 'friendly'
    moves << [x - 1, y - 1] unless x == 0 || y == 0 || @board.check_square([x - 1, y - 1], @color) == 'friendly'

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