require './lib/game.rb'

describe Game do
  game = Game.new
  describe "#switch_current_player" do
    it "should switch to player 2 from player 1" do
      expect(game.switch_current_player).to eq(game.player2)
    end

    it "should switch to player 1 from player 2" do
      expect(game.switch_current_player).to eq(game.player1)
    end
  end

  describe "#check_message" do
    it "should return a message stating that a player is in check" do
      expect(game.check_message).to eq("You are in check. Must move out of check.")
    end
  end

  describe "#checkmate_message" do
    it "should return a message declaring checkmate" do
      expect(game.checkmate_message).to eq("Checkmate!")
    end
  end

  describe "#play_again?" do
    
  end
end