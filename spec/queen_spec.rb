require './lib/pieces/queen.rb'

describe Queen do
  describe "#initialize" do
    white_queen = Queen.new(:white, [3, 0])
    black_queen = Queen.new(:black, [3, 7])

    it "should create a queen piece with the color white" do
      expect(white_queen.color).to eq(:white)
    end

    it "should create a queen piece with the color black" do
      expect(black_queen.color).to eq(:black)
    end

    it "should assign ♛ as the white queen's symbol" do
      expect(white_queen.symbol).to eq('♛')
    end

    it "should assign ♕ as the black queen's symbol" do
      expect(black_queen.symbol).to eq('♕')
    end
  end
end