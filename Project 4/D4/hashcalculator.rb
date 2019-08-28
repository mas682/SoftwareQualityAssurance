# class to run single iteration of reading a line
class HashCalculator
  # method to initialize the class
  attr_reader :table
  attr_reader :account_table

  def initialize
    @table = Array.new(84) # set table to a new array of 84 values
    @account_table = {} # set account_table to a new hash
    file = File.open('INIT.txt', 'r') # open the file INIT.txt
    i = 0 # set i to 0
    while i < 85 # loop 85 times
      @table[i] = file.readline.to_i # set table[index] to hash value of each character
      i += 1 # increment i
    end
  end

  # get the UTF value for a character
  # returns value as an array holding the value
  def get_utf(character)
    character.unpack('U')
  end

  # method gets the value of a number from a characters utf 8 value
  # num is an single element array that holds the value
  # returns a large value that is a result of the hash calculation
  def calculate_value(num)
    @table[num[0] - 40]
  end

  # method gets the hash calculation for a account number
  # accepts a account number as a argument
  # returns a value for the calculation of the account numbers hash
  def calculate_value_string(account_num)
    boolean = @account_table.key?(account_num) # see if account_table holds the account number
    return @account_table[account_num] if boolean # return value if account there

    index = 0 # index for loop
    value = 0 # set value to return to 0
    # only executes if value not in table, calculate hash value for the account number
    while index < account_num.size
      char = account_num[index]       # get the character at current index
      val = get_utf(char)             # get characters UTF8 value
      value += calculate_value(val) # increment value to include new characters calculation
      index += 1 # increment counnter
    end
    @account_table[account_num] = value # place account_num in table, with associated value
    value # return the value
  end

  # method returns hash value after taking it mod value
  def hash_val(num)
    num % 65_536
  end
end
