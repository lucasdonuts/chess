require_relative 'piece.rb'

class Knight < Piece
  def select_symbol
    @color == :white ? '♞' : '♘'
  end

  def get_moves
    dx = [2, 2, -2, -2, 1, 1, -1, -1]
    dy = [1, -1, 1, -1, 2, -2, 2, -2]

    moves = []
    
    0.upto(7) do |i|
      x = @location[0] + dx[i]
      y = @location[1] + dy[i]
      
      moves << [x, y] unless [x, y].any? {|i| i < 0 || i > 7}
      moves
    end
    
    moves.reject! { |move| move.any? {!@board.board[move[0]][move[1]].nil? && @board.board[move[0]][move[1]].color == @color} }

    moves
  end
end