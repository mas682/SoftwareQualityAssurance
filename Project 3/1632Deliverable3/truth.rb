require 'sinatra'
require 'sinatra/reloader'

# to run use ruby truth.#!/usr/bin/env ruby -wKU
# then open up a web browswer and go to localhost:4567
# program creates a truth table given 2 sybles, and a size

# Initialize the array
def array_init(width)
    height = 2 ** width  # ** used for exponential
    array = Array.new(height){Array.new(width + 4)}  # plus 4 to account for table values
    array.each{|x| x.fill(0)}  # initialize all values to 0
end

# method used to set true/false values (does not get and/or values)
def init_truth(array, width)
  row = 0                    # used to keep track of which row currently accessing
  column = 0                 # used to keep track of which column currently accessing
  size = width - 1           # used to keep track of how many T/F values to place
  height = 2 ** width        # used to know when to break inner for loop
  while column < width       # iterate through one column at a time
    iterations = 2** size    # used to set number of true values to place in row
    second_iteration = 0     # used to set number of false values to place
    while row < height       # while not at end of column
      if iterations > 0      # if iterations less than 0, set to true
        array[row][column] = 1  # setting current index to true
        iterations = iterations - 1  # decrement number of true values left to place
        row = row + 1            # increment row currently in
        second_iteration = 2** size if iterations == 0  # if no more trues to place, set how many falses to place
      else                    # set false values
        array[row][column] = 0                      # setting current index to false
        second_iteration = second_iteration - 1     # decrement number of false values left to place
        row = row + 1                               # increment row currently in
        iterations = 2** size if second_iteration == 0   # if no more false values to place, set how many trues to place
      end
    end  # end of inner while loop
    column = column + 1               # increment column
    size = size - 1                   # decrement size to decrement number of t/f's to place in a column
    row = 0  # reset row              # go back to top row
  end  # end of outter while loop
end

def solve(array, width, ts, fs)
  total = 0
  index = 0
  array.each_with_index do |x, z|  # for each array in 2D array
    total = 0        # set total to 0
    x.each_with_index do |y, w|    # for each index in the row
      total = total + y  # get total values
      if y == 1
       array[z][w] = ts
      else
        array[z][w] = fs
      end
    end  # end of current row
    if total == width  # if total = width, and should be true
      array[index][width] = ts
      array[index][width + 2] = fs  # setting nand values
    else
     array[index][width] = fs
     array[index][width + 2] = ts
    end
    if total > 0                  # setting or values
      array[index][width + 1] = ts
      array[index][width + 3] = fs  # setting nor
    else
      array[index][width + 1] = fs
      array[index][width + 3] = ts  # setting nor
    end
    index = index + 1
  end
end

# method used to make header for table to
# ex. if size = 3..array will hold 2, 1, 0
def header_init(width)
  display_arr = Array.new(width)
  count = width -1
  display_arr.each_with_index do
    |x, y|
    display_arr[y] = count
    count = count - 1
  end
  return display_arr
end

# ****************************************
# GET REQUESTS START HERE
# ****************************************

# What to do if we can't find the route
not_found do
  status 404
  erb :error
end

# If a GET request comes in at /, do the following.

get '/' do
  # Get the parameter named true and store it in ts
  ts = params['truth']
  puts ts
  # Get the parameter named false and store it in fs(false symbol)
  fs = params['false']
  # Get the parameter named size and store it in table
  size = params['size']
  # Setting these variables here so that they are accessible
  # outside the conditional
  display = 0
  ready = 0
  error = false
  word_arr = ["AND", "OR", "NAND", "NOR"]
  array = nil
  header = nil
  # If there was parameters, this is a brand new table generator
  if ts.nil? || fs.nil? || size.nil?
    display = nil
    ready = false
    error = false
  else
    ts = 'T' if ts.size == 0   # if ts is empty, set it to T
    fs = 'F' if fs.size == 0   # if fs is empty, set it to F
    size = '3' if size.size == 0  # if size is empty, set it to 3

    # checks for truth symbols size > 1, false symbol size > 1
    # if size < 2, if true and faslse symbols the same,
    # if size contains non integer values
    if ts.size > 1 || fs.size > 1 || size.to_i <= 1 || ts == fs || size.size != size.to_i.digits.count
      puts "Not ready to display"
      display = nil
      ready = false
      error = 1
    else
      puts "Ready to display"
      display = 1
      ready = 1
      error = false
      array = array_init(size.to_i)
      init_truth(array, size.to_i)
      solve(array, size.to_i, ts, fs)
      header = header_init(size.to_i)
    end
  end

  if error
    erb :inputerror
  else
   erb :index, :locals => { display: display, ready: ready, array: array, header: header, word_arr: word_arr }
  end
end
