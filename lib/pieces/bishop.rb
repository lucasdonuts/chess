require_relative 'piece.rb'

class Bishop < Piece
  attr_reader :symbol, :color
  attr_accessor :location

  def initialize(color, location)
    @location = location
    @color = color
    @symbol = select_symbol
  end

  def select_symbol
    @color == :white ? '♝' : '♗'
  end

  def get_moves(board)
    moves = up_moves(board) + down_moves(board)
  end

  def up_moves(board)
    x = @location[0]
    i = 1
    stop_right = false
    stop_left = false
    up_moves = []

    (@location[1] + 1).upto(7) do |y|
      break if stop_right && stop_left
      unless x + i > 7 || stop_right
        if !board.board[x + i][y].nil?
          board.board[x + i][y].color == @color ? stop_right = true : up_moves << [x + i, y]
          stop_right = true
        else
          up_moves << [x + i, y]
        end
      end

      unless x - i < 0 || stop_left
        if !board.board[x - i][y].nil?
          board.board[x - i][y].color == @color ? stop_left = true : up_moves << [x - i, y]
          stop_left = true
        else
          up_moves << [x - i, y]
        end
      end
      i += 1
    end
    up_moves
  end

  def down_moves(board)
    x = @location[0]
    i = 1
    stop_right = false
    stop_left = false
    down_moves = []

    (@location[1] - 1).downto(0) do |y|
      break if stop_right && stop_left
      unless x + i > 7 || stop_right
        if !board.board[x + i][y].nil?
          board.board[x + i][y].color == @color ? stop_right = true : down_moves << [x + i, y]
          stop_right = true
        else
          down_moves << [x + i, y]
        end
      end

      unless x - i < 0 || stop_left
        if !board.board[x - i][y].nil?
          board.board[x - i][y].color == @color ? stop_left = true : down_moves << [x - i, y]
          stop_left = true
        else
          down_moves << [x - i, y]
        end
      end
      i += 1
    end
    down_moves
  end
end