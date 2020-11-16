require_relative 'piece.rb'

class Knight < Piece
  attr_reader :symbol, :location, :color

  def initialize(color, location)
    @location = location
    @color = color
    @symbol = select_symbol
  end

  def select_symbol
    @color == :white ? '♞' : '♘'
  end

  def get_moves
    dx = [2, 2, -2, -2, 1, 1, -1, -1]
    dy = [1, -1, 1, -1, 2, -2, 2, -2]

    moves = []
    
    8.times do |i|
      moves << [@location[0] + dx[i], @location[1] + dy[i]]
    end
    
    moves.reject! { |p| p.any? {|i| i < 0 || i > 7 } }

    moves
  end
end