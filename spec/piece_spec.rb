# spec/piece_spec.rb
require_relative '../lib/piece'
require_relative '../lib/board'

RSpec.describe Piece do
  let(:board) { Board.new }

  describe '#possible_moves' do
    it 'returns correct pawn moves' do
      pawn = Piece.new(:pawn, :white)
      moves = pawn.possible_moves(6, 4, board)
      expect(moves).to include([5, 4], [4, 4])
    end

    it 'returns correct knight moves' do
      knight = Piece.new(:knight, :white)
      moves = knight.possible_moves(7, 1, board)
      expect(moves).to include([5, 2], [5, 0])
    end
  end
end