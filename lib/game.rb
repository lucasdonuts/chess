require_relative 'player.rb'
require_relative 'board.rb'
require_relative 'pieces/piece.rb'
require_relative 'pieces/king.rb'
require_relative 'pieces/pawn.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/queen.rb'

class Game
  attr_reader :player1, :player2, :current_player
  def initialize
    @player1 = Player.new('Player 1', 'white')
    @player2 = Player.new('Player 2', 'black')
    @board = Board.new

    @current_player = @player1
  end

  def switch_current_player
    if @current_player == @player1
      @current_player = @player2
    else
      @current_player = @player1
    end
  end

  def check_message
    "You are in check. Must move out of check."
  end

  def checkmate_message
    "Checkmate!"
  end

  
end