require_relative 'piece.rb'

class Rook < Piece
  attr_reader :symbol, :color
  attr_accessor :location

  def initialize(color, location)
    @location = location
    @color = color
    @symbol = select_symbol
  end

  def select_symbol
    @color == :white ? '♜' : '♖'
  end

  def get_moves(board)
    moves = up_moves(board) + down_moves(board) + left_moves(board) + right_moves(board)
  end

  def up_moves(board)
    x = @location[0]
    up_moves = []

    (@location[1] + 1).upto(7) do |i|
      if !board.board[x][i].nil?
        board.board[x][i].color == @color ? break : up_moves << [x, i]
        break
      else
        up_moves << [x, i]
      end
    end
    up_moves
  end

  def down_moves(board)
    x = @location[0]
    down_moves = []

    (@location[1] - 1).downto(0) do |i|
      if !board.board[x][i].nil?
        board.board[x][i].color == @color ? break : down_moves << [x, i]
        break
      else
        down_moves << [x, i]
      end
    end
    down_moves
  end

  def left_moves(board)
    y = @location[1]
    left_moves = []

    (@location[0] - 1).downto(0) do |i|
      if !board.board[i][y].nil?
        board.board[i][y].color == @color ? break : left_moves << [i, y]
        break
      else
        left_moves << [i, y]
      end
    end
    left_moves
  end

  def right_moves(board)
    y = @location[1]
    right_moves = []

    (@location[0] + 1).upto(7) do |i|
      if !board.board[i][y].nil?
        board.board[i][y].color == @color ? break : right_moves << [i, y]
        break
      else
        right_moves << [i, y]
      end
    end
    right_moves
  end
end