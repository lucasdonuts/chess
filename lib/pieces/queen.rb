require_relative 'piece.rb'

class Queen < Piece
  def select_symbol
    @color == :white ? '♛' : '♕'
  end

  def get_moves
    moves = vertical_moves + horizontal_moves + up_diagonal_moves + down_diagonal_moves
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

  def up_diagonal_moves
    x = @location[0]
    i = 1
    stop_right = false
    stop_left = false
    up_diagonal_moves = []

    (@location[1] + 1).upto(7) do |y|
      break if stop_right && stop_left
      unless x + i > 7 || stop_right
        if !@board.board[x + i][y].nil?
          @board.board[x + i][y].color == @color ? stop_right = true : up_diagonal_moves << [x + i, y]
          stop_right = true
        else
          up_diagonal_moves << [x + i, y]
        end
      end

      unless x - i < 0 || stop_left
        if !@board.board[x - i][y].nil?
          @board.board[x - i][y].color == @color ? stop_left = true : up_diagonal_moves << [x - i, y]
          stop_left = true
        else
          up_diagonal_moves << [x - i, y]
        end
      end
      i += 1
    end
    up_diagonal_moves
  end

  def down_diagonal_moves
    x = @location[0]
    i = 1
    stop_right = false
    stop_left = false
    down_diagonal_moves = []

    (@location[1] - 1).downto(0) do |y|
      break if stop_right && stop_left
      unless x + i > 7 || stop_right
        if !@board.board[x + i][y].nil?
          @board.board[x + i][y].color == @color ? stop_right = true : down_diagonal_moves << [x + i, y]
          stop_right = true
        else
          down_diagonal_moves << [x + i, y]
        end
      end

      unless x - i < 0 || stop_left
        if !@board.board[x - i][y].nil?
          @board.board[x - i][y].color == @color ? stop_left = true : down_diagonal_moves << [x - i, y]
          stop_left = true
        else
          down_diagonal_moves << [x - i, y]
        end
      end
      i += 1
    end
    down_diagonal_moves
  end
end