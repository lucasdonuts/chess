class Board
  def initialize
    @board = Array.new(8){Array.new(8)}
    place_starting_pieces
  end

  def display_board
    print "\n\n\n                 a   b   c   d   e   f   g   h \n"
    puts "                 -   -   -   -   -   -   -   - "
    7.downto(0) do |x|
      print "             #{x + 1} | "
      0.upto(7) do |y|
        print @board[y][x].nil? ? "  | " : "#{@board[y][x].symbol} | "
      end
      print "#{x + 1}"
      print "\n                 -   -   -   -   -   -   -   - \n"
    end
    print "                 a   b   c   d   e   f   g   h \n"
    puts "\n\n\n"
  end

  def place_starting_pieces # Still haven't copied piece name assignments, not sure if necessary
    (0..7).each do |x|
      @board[x][1] = Pawn.new(:white)
      @board[x][6] = Pawn.new(:black)
    end
    @board[0][0] = Rook.new(:white)
    @board[7][0] = Rook.new(:white)
    @board[1][0] = Knight.new(:white)
    @board[6][0] = Knight.new(:white)
    @board[2][0] = Bishop.new(:white)
    @board[5][0] = Bishop.new(:white)
    @board[3][0] = Queen.new(:white)
    @board[4][0] = King.new(:white)

    @board[0][7] = Rook.new(:black)
    @board[7][7] = Rook.new(:black)
    @board[1][7] = Knight.new(:black)
    @board[6][7] = Knight.new(:black)
    @board[2][7] = Bishop.new(:black)
    @board[5][7] = Bishop.new(:black)
    @board[3][7] = Queen.new(:black)
    @board[4][7] = King.new(:black)
  end
end