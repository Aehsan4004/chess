# lib/piece.rb

class Piece
  attr_reader :type, :color

  UNICODE = {
    pawn: { white: "\u2659", black: "\u265F" },
    rook: { white: "\u2656", black: "\u265C" },
    knight: { white: "\u2658", black: "\u265E" },
    bishop: { white: "\u2657", black: "\u265D" },
    queen: { white: "\u2655", black: "\u265B" },
    king: { white: "\u2654", black: "\u265A" }
  }

  def initialize(type, color)
    @type = type
    @color = color
  end

  def to_s
    UNICODE[@type][@color]
  end

  def possible_moves(x, y, board)
    case @type
    when :pawn then pawn_moves(x, y, board)
    when :rook then rook_moves(x, y, board)
    when :knight then knight_moves(x, y)
    when :bishop then bishop_moves(x, y, board)
    when :queen then queen_moves(x, y, board)
    when :king then king_moves(x, y)
    end
  end

  private

  # lib/piece.rb

  def pawn_moves(x, y, board)
    moves = []
    dir = @color == :white ? -1 : 1
    start_row = @color == :white ? 6 : 1
  
    # Forward move
    moves << [x + dir, y] if (0..7).include?(x + dir) && board.grid[x + dir][y].nil?
    # Double move from start
    moves << [x + dir * 2, y] if x == start_row && board.grid[x + dir][y].nil? && board.grid[x + dir * 2][y].nil?
    # Captures
    [[x + dir, y - 1], [x + dir, y + 1]].each do |pos|
      next unless (0..7).include?(pos[0]) && (0..7).include?(pos[1])
      target = board.grid[pos[0]][pos[1]]
      moves << pos if target && target.color != @color
    end
    moves
  end
  
  def rook_moves(x, y, board)
    moves = []
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dx, dy|
      1.upto(7) do |step|
        nx, ny = x + dx * step, y + dy * step
        break unless (0..7).include?(nx) && (0..7).include?(ny)
        target = board.grid[nx][ny]
        moves << [nx, ny]
        break if target && target.color == @color
      end
    end
    moves
  end

  def knight_moves(x, y)
    [[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2]]
      .map { |dx, dy| [x + dx, y + dy] }
      .select { |pos| (0..7).include?(pos[0]) && (0..7).include?(pos[1]) }
  end

  def bishop_moves(x, y, board)
    moves = []
    [[1, 1], [1, -1], [-1, 1], [-1, -1]].each do |dx, dy|
      1.upto(7) do |step|
        nx, ny = x + dx * step, y + dy * step
        break unless (0..7).include?(nx) && (0..7).include?(ny)
        target = board.grid[nx][ny]
        moves << [nx, ny]
        break if target && target.color == @color
      end
    end
    moves
  end

  def queen_moves(x, y, board)
    rook_moves(x, y, board) + bishop_moves(x, y, board)
  end

  def king_moves(x, y)
    [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
      .map { |dx, dy| [x + dx, y + dy] }
      .select { |pos| (0..7).include?(pos[0]) && (0..7).include?(pos[1]) }
  end
end