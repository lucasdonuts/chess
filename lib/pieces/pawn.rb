require_relative 'piece.rb'

class Pawn < Piece
  def select_symbol
    @color == :white ? '♟' : '♙'
  end

  # def get_captures
  #   captures = []
  #   case @color
  #   when :white
  #     right = @board.board[@location[0] + 1][@location[1] + 1] unless @location[0] + 1 > 7
  #     left = @board.board[@location[0] - 1][@location[1] + 1] unless @location[0] - 1 < 0
  #   when :black
  #     right = @board.board[@location[0] + 1][@location[1] - 1] unless @location[0] + 1 > 7
  #     left = @board.board[@location[0] - 1][@location[1] - 1] unless @location[0] - 1 < 0
  #   end
  #   captures << right.location unless right.nil?
  #   captures << left.location unless left.nil?
  #   captures
  # end

  def get_captures
    captures = []
    case @color
    when :white
      right = [@location[0] + 1, @location[1] + 1] unless @location[0] + 1 > 7
      left = [@location[0] - 1, @location[1] + 1] unless @location[0] - 1 < 0
    when :black
      right = [@location[0] + 1, @location[1] - 1] unless @location[0] + 1 > 7
      left = [@location[0] - 1, @location[1] - 1] unless @location[0] - 1 < 0
    end
    captures << right
    captures << left
    captures.delete_if {|move| move.nil? || @board.check_square(move, @color) != 'enemy' && @board.check_square(move, @color) != 'en passant' }
    captures
  end

  def get_moves
    moves = get_captures
    case @color
    when :white
      if !@board.board[@location[0]][@location[1] + 1].nil?
        return moves
      elsif @first_move
        moves << [@location[0], @location[1] + 1]
        moves << [@location[0], @location[1] + 2] if @board.board[@location[0]][@location[1] + 2].nil?
      else
        moves << [@location[0], @location[1] + 1]
      end
    when :black
      if !@board.board[@location[0]][@location[1] - 1].nil?
        return moves
      elsif @first_move
        moves << [@location[0], @location[1] - 1]
        moves << [@location[0], @location[1] - 2] if @board.board[@location[0]][@location[1] - 2].nil?
      else
        moves << [@location[0], @location[1] - 1]
      end
    end
    moves.reject!{|move| move.any?{|i| i < 0 || i > 7 }}
    moves
  end
end