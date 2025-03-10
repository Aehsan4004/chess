# lib/game.rb
require_relative 'board'
require_relative 'player'
require_relative 'ai_player'

class Game
  def initialize(player1_type = Player, player2_type = Player)
    @board = Board.new
    @players = [
      player1_type.new(:white, "White"),
      player2_type.new(:black, "Black")
    ]
    @current_player = 0
  end

  def play
    loop do
      @board.display
      player = @players[@current_player]
      puts "#{player.name}'s turn."
      if @board.checkmate?(player.color)
        puts "Checkmate! #{player.name} loses!"
        break
      elsif @board.in_check?(player.color)
        puts "Check!"
      end

      move = player.get_move(@board)
      if move == 'save'
        save_game
        next
      end

      unless process_move(move, player.color)
        from, to = move.split if move =~ /^[a-h][1-8] [a-h][1-8]$/
        if from && to
          from_x, from_y = @board.send(:parse_position, from)
          to_x, to_y = @board.send(:parse_position, to)
          piece = @board.grid[from_x][from_y]
          if !piece
            puts "No piece at #{from}!"
          elsif piece.color != player.color
            puts "That’s not your piece at #{from}!"
          elsif !piece.possible_moves(from_x, from_y, @board).include?([to_x, to_y])
            puts "Illegal move! #{piece.type.capitalize} can’t move from #{from} to #{to}."
          else
            puts "Illegal move! That would leave you in check."
          end
        else
          puts "Invalid input! Use format 'e2 e4' or 'save'."
        end
        next
      end

      @current_player = (@current_player + 1) % 2
    end
  end

  def save_game
    File.write('chess_save.dat', @board.serialize)
    puts "Game saved!"
  end

  def self.load_game(player1_type = Player, player2_type = Player)
    data = File.read('chess_save.dat')
    game = new(player1_type, player2_type)
    game.instance_variable_set(:@board, Board.deserialize(data))
    game
  end

  private

  def process_move(move, color)
    return false unless move =~ /^[a-h][1-8] [a-h][1-8]$/
    from, to = move.split
    @board.move(from, to, color)
  end
end