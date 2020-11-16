require './lib/pieces/bishop.rb'

describe Bishop do
  describe "#initialize" do
    white_bishop = Bishop.new('white')
    black_bishop = Bishop.new('black')

    it "should create a bishop piece with the color white" do
      expect(white_bishop.color).to eq('white')
    end

    it "should create a bishop piece with the color black" do
      expect(black_bishop.color).to eq('black')
    end

    it "should assign ♝ as a white bishop's symbol" do
      expect(white_bishop.symbol).to eq('♝')
    end

    it "should assign ♗ as the the black bishop's symbol" do
      expect(black_bishop.symbol).to eq('♗')
    end
  end
end