class Pawn < Piece
  attr_reader :symbol, :location, :color

  def initialize(color, location)
    @location = location
    @color = color
    @symbol = select_symbol
  end

  def select_symbol
    @color == :white ? '♟' : '♙'
  end

  def get_moves
    
  end
end