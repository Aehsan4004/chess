# lib/player.rb

class Player
  attr_reader :color, :name

  def initialize(color, name)
    @color = color
    @name = name
  end

  def get_move(board = nil)  # Add optional board parameter
    print "#{@name} (#{@color}), enter move (e.g., 'e2 e4' or 'save'): "
    gets.chomp
  end
end