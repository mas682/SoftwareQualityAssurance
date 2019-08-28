require_relative './location.rb'
require_relative './game_start.rb'
require_relative './location_array.rb'
require_relative './game_functions.rb'

# Matt Stropkey
# 1632 Project2
# To run program, use ruby ruby_rush.rb x y z where x, y, and z are integers.
# EXECUTION STARTS HERE
# Only exucutes if num of args equals 3

def arg_error
  puts "Usage:\nruby ruby_rush.rb *seed* *num_prospectors* *num_turns*\n*seed* should be an integer\n*num_prospectors*"\
       " should be a non-negative integer\n*num_turns* should be a non-negative integer"
  exit 1
end
arg_error if ARGV.count != 3
seed = ARGV[0].to_i
prosp = ARGV[1].to_i
turns = ARGV[2].to_i
arg_error if seed.zero? && ARGV[0] != '0' || ARGV[1].to_i.zero? || ARGV[2].to_i.zero? || prosp <= 0 || turns <= 0
arg_error if prosp.digits.count != ARGV[1].length || turns.digits.count != ARGV[2].length

game = GameStart.new(turns)
game_fun = GameFunctions.new
locations = LocationArray.new
iteration = 1
while iteration <= prosp
  game.round(iteration, locations, Random.new(seed), game_fun)
  iteration += 1
end
exit 0
