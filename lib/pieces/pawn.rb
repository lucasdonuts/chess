class Pawn < Piece
  attr_reader :symbol

  def initialize(color)
    @color = color
    @symbol = select_symbol
  end

  def select_symbol
    @color == 'white' ? '♟' : '♙'
  end

end