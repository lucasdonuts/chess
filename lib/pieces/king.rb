require_relative 'piece.rb'

class King < Piece
  attr_reader :symbol, :color
  attr_accessor :location

  def initialize(color, location)
    @location = location
    @color = color
    @symbol = select_symbol
  end

  def select_symbol
    @color == :white ? '♚' : '♔'
  end
end