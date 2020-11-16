require './lib/pieces/rook.rb'

describe Rook do
  describe "#initialize" do
    white_rook = Rook.new('white')
    black_rook = Rook.new('black')

    it "should create a rook piece with the color white" do
      expect(white_rook.color).to eq('white')
    end

    it "should create a rook piece with the color black" do
      expect(black_rook.color).to eq('black')
    end

    it "should assign ♜ as the white rook's symbol" do
      expect(white_rook.symbol).to eq('♜')
    end

    it "should assign ♖ as the black rook's symbol" do
      expect(black_rook.symbol).to eq('♖')
    end
  end
end