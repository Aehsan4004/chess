# spec/game_spec.rb
require_relative '../lib/game'

RSpec.describe Game do
  describe '#process_move' do
    it 'processes valid moves' do
      game = Game.new
      expect(game.send(:process_move, 'e2 e4', :white)).to be true
    end

    it 'rejects invalid input' do
      game = Game.new
      expect(game.send(:process_move, 'e9 e0', :white)).to be false
    end
  end
end