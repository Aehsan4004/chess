# lib/ai_player.rb
require_relative 'player'

class AIPlayer < Player
  def get_move(board)
    legal_moves = []
    8.times do |x|
      8.times do |y|
        piece = board.grid[x][y]
        next unless piece && piece.color == @color
        from = "#{('a'.ord + y).chr}#{8 - x}"
        piece.possible_moves(x, y, board).each do |to_x, to_y|
          to = "#{('a'.ord + to_y).chr}#{8 - to_x}"
          legal_moves << "#{from} #{to}" if board.valid_move?(x, y, to_x, to_y)
        end
      end
    end
    legal_moves.sample  # Random legal move
  end
end