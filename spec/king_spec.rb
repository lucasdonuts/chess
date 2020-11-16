require './lib/pieces/king.rb'

describe King do
  describe "#initialize" do
    white_king = King.new('white')
    black_king = King.new('black')

    it "should create a king piece with the color white" do
      expect(white_king.color).to eq('white')
    end

    it "should create a king piece with the color black" do
      expect(black_king.color).to eq('black')
    end

    it "should assign ♚ as the white king's symbol" do
      expect(white_king.symbol).to eq('♚')
    end

    it "should assign ♔ as the black king's symbol" do
      expect(black_king.symbol).to eq('♔')
    end
  end
end