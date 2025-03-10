# main.rb
require_relative 'lib/game'

puts "Welcome to Chess!"
puts "1. Two Players"
puts "2. Player vs AI"
print "Choose mode: "
mode = gets.chomp.to_i

game = mode == 2 ? Game.new(Player, AIPlayer) : Game.new
game.play