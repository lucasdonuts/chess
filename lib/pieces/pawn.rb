class Pawn
  attr_reader :color
  attr_accessor :first_move, :location, :symbol

  def initialize(color, location)
    @location = location
    @color = color
    @symbol = select_symbol
    @first_move = true
  end

  def select_symbol
    @color == :white ? '♟' : '♙'
  end

  def get_captures(board)
    captures = []
    case @color
    when :white
      right = board.board[@location[0] + 1][@location[1] + 1] unless @location[0] + 1 > 7
      left = board.board[@location[0] - 1][@location[1] + 1] unless @location[0] - 1 < 0
    when :black
      right = board.board[@location[0] + 1][@location[1] - 1] unless @location[0] + 1 > 7
      left = board.board[@location[0] - 1][@location[1] - 1] unless @location[0] - 1 < 0
    end
    captures << right.location unless right.nil?
    captures << left.location unless left.nil?
    captures
  end

  def get_moves(board)
    moves = get_captures(board)
    case @color
    when :white
      if !board.board[@location[0]][@location[1] + 1].nil?
        return moves
      elsif @first_move
        moves << [@location[0], @location[1] + 1]
        moves << [@location[0], @location[1] + 2] if board.board[@location[0]][@location[1] + 2].nil?
      else
        moves << [@location[0], @location[1] + 1]
      end
    when :black
      if !board.board[@location[0]][@location[1] - 1].nil?
        return moves
      elsif @first_move
        moves << [@location[0], @location[1] - 1]
        moves << [@location[0], @location[1] - 2] if board.board[@location[0]][@location[1] - 2].nil?
      else
        moves << [@location[0], @location[1] - 1]
      end
    end
    moves
  end
end

pawn = Pawn.new(:white, [3, 1])
