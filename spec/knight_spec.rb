require './lib/pieces/knight.rb'

describe Knight do
  white_knight = Knight.new(:white, [1, 0])
  black_knight = Knight.new(:black, [1, 7])

  describe "#initialize" do
    it "should create a knight piece with the color white" do
      expect(white_knight.color).to eq(:white)
    end

    it "should create a knight piece with the color black" do
      expect(black_knight.color).to eq(:black)
    end

    it "should assign ♞ as the white knight's symbol" do
      expect(white_knight.symbol).to eq('♞')
    end

    it "should assign ♘ as the black knight's symbol" do
      expect(black_knight.symbol).to eq('♘')
    end
  end

  describe "#get_moves" do
    knight = Knight.new('white', [1, 0])
    it "should return an array" do
      expect(knight.get_moves).to be_a(Array)
    end
  end
end