# spec/board_spec.rb
require_relative '../lib/board'
require_relative '../lib/piece'

RSpec.describe Board do
  describe '#move' do
    it 'moves a pawn correctly' do
      board = Board.new
      expect(board.move('e2', 'e4', :white)).to be true
      expect(board.grid[4][4]).to be_a(Piece)
      expect(board.grid[6][4]).to be_nil
    end

    it 'prevents illegal moves' do
      board = Board.new
      expect(board.move('e2', 'e5', :white)).to be false
    end
  end

  describe '#in_check?' do
    it 'detects check' do
      board = Board.new
      board.move('e2', 'e4', :white)
      board.move('e7', 'e5', :black)
      board.move('d1', 'h5', :white)
      expect(board.in_check?(:black)).to be true
    end
  end
end