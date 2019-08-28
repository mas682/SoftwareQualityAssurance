# class to check if blocks are valid
class BlockChecker
  # initialize method
  # file = file passed in at command line
  def initialize(file)
    @file = file
  end

  # method checks to see if two hash values equal
  # returns false if not equal, true otherwise
  def check_hash(calculated_hash, stored_hash)
    return false if stored_hash != calculated_hash

    true
  end

  # method checks to see if two numbers equal
  # returns false if not equal, true otherwise
  def check_block_num(counter, block_num)
    return nil if counter != block_num

    true
  end

  # method checks a string for capital letters
  # returns nil if a letter is capitalized, true otherwise
  def check_capital(hash_string)
    i = 0 # index for string
    max = hash_string.size # for while loop
    while i < max
      value = hash_string[i].unpack('U') # get value of character
      return nil if value[0] < 91 && value[0] > 64 # if capital, return nil

      i += 1 # go to next character in string
    end
    true
  end

  # checks to make sure all values in a string are hex values
  # returns true if all values are hex values, otherwise nil
  def check_hex(hash_string)
    i = 0 # index for string
    max = hash_string.size # for while loop
    while i < max
      value = hash_string[i].unpack('U') # get the characters value
      return nil if value[0] < 48 || value[0] > 57 && value[0] < 97 || value[0] > 102

      i += 1
    end
    true
  end

  # method checks to see if a string is only digits
  # returns true if all values are digits, nil otherwise
  def check_digits(account_num)
    i = 0 # index for string
    max = account_num.size # to control while loop
    while i < max
      value = account_num[i].unpack('U')
      return nil unless value[0] > 47 && value[0] < 58

      i += 1
    end
    true
  end

  # method verifies if a string is in fact 0, if string.to_i
  # returns nil if string is 0, 1 if not zero
  def verify_zero(string, hash_calc)
    real_val = hash_calc.get_utf(string)
    return 1 if real_val[0] != 48

    nil
  end

  # method checks if the last character of a string is a certaint character
  # returns nil if string contains that character at end, false otherwise
  def check_last_char(string, character)
    string_len = string.size - 1
    return false if string[string_len] != character

    nil
  end

  # method checks to see if a string of coins is valid
  # returns nil if not valid, number of coins if valid
  def check_coins(coins)
    number_coins = coins.to_i # convert string to integer
    coins_len = coins.size # get size of string that holds coin value
    number_coins_len = number_coins.digits.size # get number of digits output by to_i
    return nil if coins_len != number_coins_len

    return nil if number_coins <= 0

    number_coins
  end

  # method subtracts coins from an account
  def subtract_account(account_tracker, account, number_coins)
    exists = account_tracker.account_exists?(account)
    account_tracker.remove_balance(account, number_coins) if exists
    account_tracker.add_account(account) unless exists
    account_tracker.remove_balance(account, number_coins) unless exists
  end

  # method adds coins to an account
  def add_account(account_tracker, second_account, number_coins)
    acc_two_exists = account_tracker.account_exists?(second_account)
    account_tracker.add_balance(second_account, number_coins) if acc_two_exists
    account_tracker.add_account(second_account) unless acc_two_exists
    account_tracker.add_balance(second_account, number_coins) unless acc_two_exists
  end

  # method validates a timestamp is a integer
  # takes a string as time stamp
  # returns nil if not a integer, otherwise, returns time as a integer
  def validate_time(time, hash_calc)
    real_time = time.to_i # convert time to a integer
    time_len = time.size # get lenght of string
    real_len = real_time.digits.size # get lenght of integer
    return nil if time_len != real_len # if lenghts not equal, return nil

    if real_time.zero? # if time = 0
      time_val = hash_calc.get_utf(time) # get value of string in UTF8
      return nil if time_val[0] != 48 # if string is not actually 0, return nil
    end
    real_time
  end

  # method to read a line from the file
  # returns a string if read, nil if at end of file
  def read_next_line
    return nil if @file.eof?

    @file.readline
  end

  # block is a string
  # sybmbol is a symbol to break string up with
  # returns a array of broken up strings based on the symbol
  def parse(block, symbol)
    block.split(symbol)
  end

  # gets the number of coins transfered for a transaction
  # by getting the value inbetween parentheses
  # returns the vaue in the parentheses
  # string in format abc(123)
  def get_coins(string)
    string[/\((.*?)\)/, 1]
  end

  # method returns hash in decimal of first 4 blocks
  # accepts a hash calulator and a string, which must have
  # 4 '|' or it will run forever
  def get_hash(string, hash_calc)
    i = 0 # initialize i to 0
    counter = 0 # counter for number of | encountered
    total = 0 # total to use for hash
    while counter < 2
      char = string[i] # get the first character
      counter += 1 if char == '|' # increment counter if |
      # break if counter == 4 # if counter == 4, no more characters need read
      # new
      val = hash_calc.get_utf(char) # get value of character
      total += hash_calc.calculate_value(val) # increment total
      i += 1 # increment index in string
    end
    # if counter equals 2, at transactions
    if counter == 2
      b = 0 # counter for transactions
      blocks = parse(string, '|') # break up string to blocks
      transactions = parse(blocks[2], ':') # get each individual transaction
      while b < transactions.size
        accounts = parse(transactions[b], '>') # seperate account numbers
        second_account = parse(accounts[1], '(') # seperate second account number from ()
        total += hash_calc.calculate_value_string(accounts[0]) # get hash of first account number
        total += hash_calc.calculate_value([62]) # get hash for > character
        total += hash_calc.calculate_value_string(second_account[0]) # get hash for second acccount
        i += 13 # increment by 13 to go to () in transaction
        char = string[i] # set char to (
        # while not at end of a transaction or end of transaction block
        while char != ':' && char != '|'
          val = hash_calc.get_utf(char) # get hash of current character
          total += hash_calc.calculate_value(val) # update total
          i += 1 # increment string index counter
          char = string[i] # set char to next character
        end
        counter += 1 if char == '|' # increment counter if at end of transaction block
        break if char == '|' # if char == |, no more transactions

        # if break missed, account for : character
        total += hash_calc.calculate_value([58]) # account for :
        i += 1 # increment string index
        b += 1 # increment transaction index
      end
    end
    # not in transaction block
    while counter < 4
      val = hash_calc.get_utf(char) # get value of character
      total += hash_calc.calculate_value(val) # increment total
      i += 1 # increment index in string
      char = string[i]
      counter += 1 if char == '|'
    end
    hash_calc.hash_val(total) # return hash of total
  end
end
