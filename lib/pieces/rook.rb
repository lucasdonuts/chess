require_relative 'piece.rb'

class Rook < Piece
  attr_reader :side

  def initialize(color, location, board)
    @location = location
    @side = location[0] == 0 ? :left : :right
    @color = color
    @symbol = select_symbol
    @first_move = true
    @board = board
  end

  def select_symbol
    @color == :white ? '♜' : '♖'
  end

  def get_moves
    moves = vertical_moves + horizontal_moves
  end

  def vertical_moves
    x = @location[0]
    vertical_moves = []

    (@location[1] + 1).upto(7) do |y|
      if !@board.board[x][y].nil?
        @board.board[x][y].color == @color ? break : vertical_moves << [x, y]
        break
      else
        vertical_moves << [x, y]
      end
    end

    (@location[1] - 1).downto(0) do |y|
      if !@board.board[x][y].nil?
        @board.board[x][y].color == @color ? break : vertical_moves << [x, y]
        break
      else
        vertical_moves << [x, y]
      end
    end
    vertical_moves
  end

  def horizontal_moves
    y = @location[1]
    horizontal_moves = []

    (@location[0] - 1).downto(0) do |x|
      if !@board.board[x][y].nil?
        @board.board[x][y].color == @color ? break : horizontal_moves << [x, y]
        break
      else
        horizontal_moves << [x, y]
      end
    end

    (@location[0] + 1).upto(7) do |x|
      if !@board.board[x][y].nil?
        @board.board[x][y].color == @color ? break : horizontal_moves << [x, y]
        break
      else
        horizontal_moves << [x, y]
      end
    end
    horizontal_moves
  end
end