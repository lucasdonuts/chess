require './lib/game.rb'

describe Game do
  game = Game.new

  describe "#valid_input?" do
    it "should return true if input is in (letter)(number) format" do
      expect(game.valid_input?(["a", "1"])).to be true
    end

    it "should return false if letter is not between a-h" do
      expect(game.valid_input?(["x", "1"])).to be false
    end

    it "should return false if number is not between 1-8" do
      expect(game.valid_input?(["a", "13"])).to be false
    end

    it "should return false if the wrong number of characters are entered" do
      expect(game.valid_input?(["a", "1", "3"])).to be false
    end
  end

  describe "#translate_input" do
    it "should translate a1 to [0, 0]" do
      expect(game.translate_input(["a", "1"])).to eq([0, 0])
    end

    it "should translate h8 to [7, 7]" do
      expect(game.translate_input(["h", "8"])).to eq([7, 7])
    end
  end
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
end