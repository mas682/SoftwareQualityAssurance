# require 'flamegraph'

require_relative 'hashcalculator.rb'
require_relative 'blockreader.rb'
require_relative 'blockchecker.rb'
require_relative 'accounts.rb'
# Matt Stropkey
# 1632 Project4
# To run program, use ruby verifier.rb file.txt.
# EXECUTION STARTS HERE
# Only exucutes if num of args equals 3

# method crashes the program
def arg_error
  puts "Usage:\nruby verifier.rb *file.tx*\n"
  exit 1
end

# Flamegraph.generate('final_long.html') do
arg_error if ARGV.count != 1 # check to see if one argument passed in
unless File.exist?(ARGV[0])
  puts "File #{ARGV[0]} does not exist"
  exit 1
end
file = File.open(ARGV[0], 'r') # open the file that was passed as a argument
hash_calc = HashCalculator.new # create a new Hash Calculator
block = BlockReader.new # create a new Block Reader
block_checker = BlockChecker.new(file) # create a new Block Checker
account_tracker = Accounts.new # create a new Account
passed = block.read_file(hash_calc, block_checker, account_tracker) # set passed to result
unless passed.nil? # if result of read_file = nil, block correctly read
  puts passed # output error if not nil
  puts 'BLOCKCHAIN INVALID'
end
# end
exit 0
