# Most likely trash

class Piece
  attr_reader :color, :symbol
  attr_accessor :location, :first_move
  
  def initialize(color, location, board)
    @location = location
    @color = color
    @symbol = select_symbol
    @first_move = true
    @board = board
  end
end