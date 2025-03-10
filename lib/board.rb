# lib/board.rb
require_relative 'piece'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    setup_board
  end

  def setup_board
    # Pawns
    8.times { |x| @grid[1][x] = Piece.new(:pawn, :black) }
    8.times { |x| @grid[6][x] = Piece.new(:pawn, :white) }
    # Rooks
    @grid[0][0] = @grid[0][7] = Piece.new(:rook, :black)
    @grid[7][0] = @grid[7][7] = Piece.new(:rook, :white)
    # Knights
    @grid[0][1] = @grid[0][6] = Piece.new(:knight, :black)
    @grid[7][1] = @grid[7][6] = Piece.new(:knight, :white)
    # Bishops
    @grid[0][2] = @grid[0][5] = Piece.new(:bishop, :black)
    @grid[7][2] = @grid[7][5] = Piece.new(:bishop, :white)
    # Queens
    @grid[0][3] = Piece.new(:queen, :black)
    @grid[7][3] = Piece.new(:queen, :white)
    # Kings
    @grid[0][4] = Piece.new(:king, :black)
    @grid[7][4] = Piece.new(:king, :white)
  end

  def display
    puts "  a b c d e f g h"
    @grid.each_with_index do |row, i|
      print "#{8 - i} "
      row.each { |cell| print "#{cell&.to_s || ' '} " }
      print "#{8 - i}"
      puts
    end
    puts "  a b c d e f g h"
  end

  def move(from, to, color)
    from_x, from_y = parse_position(from)
    to_x, to_y = parse_position(to)
    piece = @grid[from_x][from_y]

    return false unless piece && piece.color == color && valid_move?(from_x, from_y, to_x, to_y)
    
    @grid[to_x][to_y] = piece
    @grid[from_x][from_y] = nil
    true
  end

  def valid_move?(from_x, from_y, to_x, to_y)
    piece = @grid[from_x][from_y]
    return false unless piece && within_bounds?(to_x, to_y)

    moves = piece.possible_moves(from_x, from_y, self)
    moves.include?([to_x, to_y]) && !move_into_check?(from_x, from_y, to_x, to_y)
  end

  def in_check?(color)
    king_pos = find_king(color)
    opponent_color = color == :white ? :black : :white
    8.times do |x|
      8.times do |y|
        piece = @grid[x][y]
        next unless piece && piece.color == opponent_color
        return true if piece.possible_moves(x, y, self).include?(king_pos)
      end
    end
    false
  end

  def checkmate?(color)
    return false unless in_check?(color)
    8.times do |x|
      8.times do |y|
        piece = @grid[x][y]
        next unless piece && piece.color == color
        piece.possible_moves(x, y, self).each do |to|
          return false if try_move(x, y, to[0], to[1])
        end
      end
    end
    true
  end

  def serialize
    Marshal.dump(@grid)
  end

  def self.deserialize(data)
    board = new
    board.instance_variable_set(:@grid, Marshal.load(data))
    board
  end

  private

  def parse_position(pos)
    col = pos[0].downcase.ord - 'a'.ord
    row = 8 - pos[1].to_i
    [row, col]
  end

  def within_bounds?(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end

  def find_king(color)
    8.times do |x|
      8.times do |y|
        piece = @grid[x][y]
        return [x, y] if piece&.type == :king && piece.color == color
      end
    end
  end

  def move_into_check?(from_x, from_y, to_x, to_y)
    original = @grid[to_x][to_y]
    piece = @grid[from_x][from_y]
    @grid[to_x][to_y] = piece
    @grid[from_x][from_y] = nil
    check = in_check?(piece.color)
    @grid[from_x][from_y] = piece
    @grid[to_x][to_y] = original
    check
  end

  def try_move(from_x, from_y, to_x, to_y)
    original = @grid[to_x][to_y]
    piece = @grid[from_x][from_y]
    return false unless valid_move?(from_x, from_y, to_x, to_y)
    @grid[to_x][to_y] = piece
    @grid[from_x][from_y] = nil
    safe = !in_check?(piece.color)
    @grid[from_x][from_y] = piece
    @grid[to_x][to_y] = original
    safe
  end
end