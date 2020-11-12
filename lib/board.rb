class Board
  attr_reader :board

  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def in_bounds?(move)
    (1..8).include?(move[0]) && (1..8).include?(move[1])
  end

  def square_empty?(square)
    @board[square[0]][square[1]].nil?
  end
end