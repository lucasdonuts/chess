require_relative 'player.rb'
require_relative 'board.rb'
require_relative 'pieces/piece.rb'
require_relative 'pieces/king.rb'
require_relative 'pieces/pawn.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/queen.rb'
require 'yaml'

class Game
  attr_reader :player1, :player2, :current_player
  def initialize
    @player1 = Player.new('Player 1', :white)
    @player2 = Player.new('Player 2', :black)
    @board = Board.new
    @current_player = @player1
    start_game
  end

  def start_game
    welcome_message
    check_save
  end

  def game_loop
    loop do
      @board.display_board
      check_game_state
      prompt_user_input
      switch_current_player
    end
  end

  def check_save
    if File.exist?("saves/save_file")
      load_game?
    else
      game_loop
    end
  end

  def load_game?
    puts "\nSave game found. Do you want to load it? (y/n)"
    case gets.chomp
    when 'y'
      load_game
    when 'n'
      game_loop
    else
      puts "Invalid option."
      load_game?
    end
  end

  def save_game
    Dir.mkdir("saves") unless Dir.exists?("saves")
    File.open("saves/save_file", "w+") do |info|
      Marshal.dump(self, info)
    end
  end

  def load_game
    data = nil
    File.open("saves/save_file") do |i|
      data = Marshal.load(i)
    end

    @player1 = data.player1
    @player2 = data.player2
    @board = data.board
    @current_player = data.current_player

    puts "Save file loaded"
    game_loop
  end

  def prompt_user_input
    print "\n#{@current_player.name}, enter the coordinates of the piece you would like to move: "
    get_user_input
  end

  def get_user_input
    input = gets.chomp
    check_input(input)
  end

  def check_input(input)
    case input
    when 'save'
      save_game
      exit
    when 'help'
      puts instructions
    when 'quit'
      sure_quit?
    else
      input = input.split('')
      select_piece(input)
    end
  end

  def sure_quit?
    print "\nAre you sure you want to quit? (y/n): "
    input = gets.chomp
    case input
    when 'y'
      exit
    when 'n'
      prompt_user_input
    else
      puts "\nInvalid answer."
      sure_quit?
    end
  end

  def select_piece(input)
    if valid_input?(input)
      from = translate_input(input)
      if @board.valid_selection?(from, @current_player.color)
        selected_piece = @board.board[from[0]][from[1]]
        destination = get_destination(selected_piece)
        @board.move_piece(selected_piece, destination)
      else
        puts "\nInvalid selection."
        prompt_user_input
      end
    else
      puts "\nInput invalid. Must be in letternumber format, " +
           "a-h and 1-8, like a1 or d5."
      prompt_user_input
    end
  end

  def check_game_state
    if @board.king_in_check?(@current_player.color)
      puts check_message
    elsif @board.checkmate?(@current_player.color)
      @board.display_board
      puts checkmate_message
      game_over
    end
  end

  def welcome_message
    puts "\nWelcome to chess! Player 1 will be white and Player 2 will be black." +
         " White goes first."
    puts instructions
  end

  def instructions
    "\n     Input your piece selection, or enter the following options at any time" +
    "\n         Type 'help' for options" +
    "\n         Type 'save' to save and quit your game" +
    "\n         Type 'quit' to quit without saving"
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
    winner = @current_player.color == :white ? @player2 : @player1
    puts "Checkmate! #{winner.name}, you win!"
  end
end