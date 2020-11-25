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

  def get_moves
    moves = []
    x = @location[0]
    y = @location[1]

    moves << [x, y + 1]  
    moves << [x, y - 1]  
    moves << [x + 1, y]  
    moves << [x + 1, y + 1]
    moves << [x + 1, y - 1]
    moves << [x - 1, y]  
    moves << [x - 1, y + 1]
    moves << [x - 1, y - 1]

    moves += castling_moves

    moves.reject! {|move| move.any? {|i| i < 0 || i > 7 }}
    moves
  end

  def castling_moves
   
  end
end