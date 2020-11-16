require './lib/pieces/pawn.rb'

describe Pawn do
  describe "#initialize" do
    white_pawn = Pawn.new('white')
    black_pawn = Pawn.new('black')

    it "should create a pawn piece with the color white" do
      expect(white_pawn.color).to eq('white')
    end

    it "should create a pawn piece with the color black" do
      expect(black_pawn.color).to eq('black')
    end

    it "should assign ♟ as the white pawn's symbol" do
      expect(white_pawn.symbol).to eq('♟')
    end

    it "should assign ♙ as the black pawn's symbol" do
      expect(black_pawn.symbol).to eq('♙')
    end
  end
end