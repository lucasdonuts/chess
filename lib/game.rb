require_relative 'player.rb'
require_relative 'board.rb'
require_relative 'pieces/piece.rb'
require_relative 'pieces/king.rb'
require_relative 'pieces/pawn.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/queen.rb'
require 'pry'

class Game
  attr_reader :player1, :player2, :current_player
  def initialize
    @player1 = Player.new('Player 1', :white)
    @player2 = Player.new('Player 2', :black)
    @board = Board.new

    @current_player = @player1
    #game_loop
  end

  def game_loop
    welcome_message
    loop do
      @board.display_board
      selected_piece = get_piece_selection
      destination = get_destination(selected_piece)
      @board.move_piece(selected_piece, destination)
      switch_current_player
      check_game_state
    end
  end

  def check_game_state
    if @board.king_in_check?(@current_player.color)
      puts check_message
    elsif @board.check_mate?(@current_player.color)
      puts checkmate_message
      game_over
    end
  end

  def welcome_message
    puts "\nWelcome to chess! Player 1 will be white and Player 2 will be black." +
         " White goes first."
  end

  def reset_game
    Game.new
  end

  def play_again?
    puts "Would you like to play again? (y/n): "
    input = gets.chomp.downcase
    case input
    when 'y'
      return true
    when 'n'
      return false
    else
      puts "Invalid input."
      play_again?
    end
  end

  def game_over
    if play_again?
      reset_game
    else
      exit
    end
  end

  def get_piece_selection
    print "\n#{@current_player.name}, enter the coordinates of the piece you would like to move: "
    from = gets.chomp.split('')
    if valid_input?(from)
      from = translate_input(from)
      if @board.valid_selection?(from, @current_player.color)
        return @board.board[from[0]][from[1]]
      else
        get_piece_selection
      end
    else
      puts "\nInput invalid. Must be in letternumber format, " +
           "a-h and 1-8, like a1 or d5."
      get_piece_selection
    end
  end

  def get_destination(piece)
    print "\nEnter destination coordinates: "
    destination = gets.chomp.split('')
    if valid_input?(destination)
      destination = translate_input(destination)
      if @board.valid_destination?(piece, destination)
        return destination
      else 
        puts "\nPiece is unable to make that move."
        get_destination(piece)
      end
    else
      puts "\nInput invalid. Must be in letternumber format, " +
           "a-h and 1-8, like a1 or d5."
      get_destination(piece)
    end
  end

  def valid_input?(input)
    ("a".."h").include?(input[0]) && (1..8).include?(input[1].to_i) && input.length == 2
  end

  def translate_input(input)
    let_num = { "a" => 0,
                "b" => 1,
                "c" => 2,
                "d" => 3,
                "e" => 4,
                "f" => 5,
                "g" => 6,
                "h" => 7
              }
    x = let_num[input[0]]
    y = input[1].to_i - 1
    translation = [x, y]
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