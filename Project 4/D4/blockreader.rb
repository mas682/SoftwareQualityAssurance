# class to read a block
class BlockReader
  # the main method to execute the program

  def read_file(hash_calc, block_check, account_tracker)
    line = 0 # used as counter for block line
    previous_hash = 0 # used to hold previous hash's value
    previous_left_time = 0 # used to hold previous leftmost time
    previous_right_time = 0 # used to hold previous rightmost time
    while line > -1
      # get line to check
      block = block_check.read_next_line
      break if block.nil? # break out of loop if no more files to read

      blocks = block_check.parse(block, '|') # seperate each of the blocks
      return "Line #{line}: Too many '|' in the block '#{block}'" if blocks.size != 5 # make sure only 5 blocks

      # checking block number
      block_num_return = block_num(blocks[0], hash_calc, block_check, line)
      return block_num_return unless block_num_return.nil?

      # checking previous hash
      previous_hash_return = previous_hash(blocks[1], previous_hash, block_check, line)
      return previous_hash_return unless previous_hash_return.nil?

      previous_hash = blocks[4].strip.to_i(16) # set value of previous hash

      # check transactions
      transactions = blocks[2]
      transaction_return = transactions(transactions, account_tracker, block_check, line)
      return transaction_return unless transaction_return.nil?

      # check time stamp
      times = time_stamp(blocks[3], [previous_left_time, previous_right_time], hash_calc, block_check, line)
      return times if times.is_a? String

      previous_right_time = times[1] # set previous right time
      previous_left_time = times[0] # set previous left time

      # check if hash correct
      hash_return = hash(block, blocks[4], hash_calc, block_check, line)
      return hash_return unless hash_return.nil?

      # increment for while loop
      line += 1
    end
    account_tracker.print_accounts # if passed all checks. print out the accoutns
    nil
  end

  # method handles verifying hash value in a block
  def hash(block, stored_hash, hash_calc, block_check, line)
    return 'Block empty' if block.nil?

    # calculate hash value for line
    error = "Line #{line}: Invalid hash set to #{stored_hash.strip}"

    # if hash stored as with capital letters, return error
    stored_hash = stored_hash.strip # get rid of trailing white space
    int_hash = stored_hash.to_i(16) # get stored hash and convert to decimal
    # check lenght of stored hash(max4)...may be optiaml to place elsewhere
    return error + "\nHash length is too big" if stored_hash.size >= 5

    # check hash for leading 0's
    return error + "\nHash contains leading zeros" if stored_hash[0] == '0' && stored_hash.size > 1

    # check to make sure value is valid hex values
    return error + "\nInvalid hex value, must be lowercase and from 0-f" unless block_check.check_hex(stored_hash)

    # see if calculated hash and stored has match
    hash = block_check.get_hash(block, hash_calc) # get hash value
    # removes last hash from string
    output_string = block_check.parse(block, '|' + stored_hash)
    error_two = "Line #{line}: String '#{output_string[0]}' hash set to #{stored_hash.strip},"\
                         "should be #{hash.to_s(16)}"
    return error_two unless block_check.check_hash(hash, int_hash)

    nil
  end

  # method handles verifying block number is correct
  def block_num(block_num, hash_calc, block_check, line)
    block_val = block_num.to_i # convert to integer
    zero = nil
    error = "Line #{line}: Invalid block number #{block_num}, should be #{line}"
    # if a value such as 2a is stored, will fail here
    return error + "\nNon-numeric value detected" if block_val.digits.size != block_num.size

    # handles case where if to_i returns 0 because string was a char and line is 0,
    # will not pass
    zero = block_check.verify_zero(block_num, hash_calc) if block_val.zero?
    return error + "\nNon-numeric value detected" unless zero.nil?
    # if the block number is not the next number
    return error unless block_check.check_block_num(line, block_val)

    nil
  end

  # method handles verifying previous hash is correct
  def previous_hash(stored_prev, actual_prev, block_check, line)
    # see if previous hash value stored correctly..less than 5 hex values
    error = "Line #{line}: Previous hash was #{stored_prev}, should be #{actual_prev.to_s(16)}"
    return error + "\nLenght of previous hash too long" if stored_prev.size >= 5

    # see if leading 0's in previous hash
    return error + "\nCannot have leading 0's in previous hash" if stored_prev[0] == '0' && stored_prev.size > 1

    # check to make sure string is only in hex values
    return error + "\nInvalid hex value, must be lowercase and from 0-f" unless block_check.check_hex(stored_prev)

    stored_prev_hash = stored_prev.to_i(16)
    # see if the two values are equal
    return error unless block_check.check_hash(actual_prev, stored_prev_hash)

    nil
  end

  def transactions(transaction, account_tracker, block_check, line)
    trans = block_check.parse(transaction, ':') # get array of transactions
    num_transactions = trans.length # get number of transactions
    a = 0 # counter for loop
    return "Line #{line}: Cannot have 0 or less transactions '#{transaction}'" if num_transactions < 1

    while a < num_transactions
      # split a transaction into two accounts
      accts = block_check.parse(trans[a], '>')
      # checks if transaction has > in it
      return "Line #{line}: Could not parse transactions list '#{transaction}'" if accts.length != 2

      # check to see if last character is )
      last_check = block_check.check_last_char(trans[a], ')')
      return "Line #{line}: Last character of transaction must be ')': '#{trans[a]}'" unless last_check.nil?

      # sees if right half of transaction has ( in it
      sec_acc = block_check.parse(accts[1], '(')
      return "Line #{line}: Too many or too few '(' in transaction #{a + 1}: '#{trans[a]}'" if sec_acc.length != 2

      # check from account size
      return "Line #{line}: Account number '#{accts[0]}' has a invalid length" if accts[0].size != 6

      # check to account size
      return "Line #{line}: Account number '#{sec_acc[0]}' has a invalid length" if sec_acc[0].size != 6

      # make sure from address only consists of numbers if not system
      if accts[0] != 'SYSTEM'
        unless block_check.check_digits(accts[0])
          return "Line #{line}: Transaction #{a + 1} contains a non-numeric value '#{accts[0]}'"
        end
      end
      # make sure to address only consists of numbers
      unless block_check.check_digits(sec_acc[0])
        return "Line #{line}: Transaction #{a + 1} contains a non-numeric value '#{sec_acc[0]}'"
      end

      # make sure first block only has one transaction
      if num_transactions > 1 && line.zero?
        return "Line #{line}: Line #{line} can only have one transaction: '#{transaction}'"
      end

      # make sure only transaction from system
      if accts[0] != 'SYSTEM' && line.zero?
        return "Line #{line}: Line #{line} can only have a transaction from the system: '#{transaction}'"
      end

      # make sure number of coins returned is a valid number
      coins = block_check.get_coins(accts[1])
      if 8 + coins.size != accts[1].size
        return "Line #{line}: Invalid coin format for transaction #{a + 1}: '#{trans[a]}'"
      end

      number_coins = block_check.check_coins(coins)
      return "Line #{line}: Invalid coin format for transaction #{a + 1}: '#{trans[a]}'" if number_coins.nil?

      # make sure SYSTEM gives 100 to user
      if accts[0] == 'SYSTEM' && number_coins != 100
        return "Line #{line}: Invalid coin format from system for transaction #{a + 1} '#{trans[a]}'"
      end

      # if the system is not the account, do this
      if accts[0] != 'SYSTEM' && a != (num_transactions - 1)
        block_check.subtract_account(account_tracker, accts[0], number_coins)
      elsif accts[0] == 'SYSTEM' && a != (num_transactions - 1)
        return "Line #{line}: The last transaction may only be from the system: '#{transaction}'"
      elsif accts[0] != 'SYSTEM' && a == (num_transactions - 1)
        return "Line #{line}: The last transaction may only be from the system: '#{transaction}'"
      end
      # add coins to account
      block_check.add_account(account_tracker, sec_acc[0], number_coins)
      a += 1
    end
    negative = account_tracker.negative_balance?
    return "Line #{line}: Invalid block, address #{negative[0]} has #{negative[1]} billcoins!" unless negative.nil?

    nil
  end

  def time_stamp(time, time_arr, hash_calc, block_check, line)
    previous_left_time = time_arr[0]
    previous_right_time = time_arr[1]
    original = time
    time = block_check.parse(time, '.')
    # checks to make sure the . is in the time block
    last_index = original.size - 1
    return "Line #{line}: Time stamp cannot end in '.': #{original}" if original[last_index] == '.'

    return "Line #{line}: Time stamp has too few or too many '.': #{original}" if time.size != 2

    # see if leftmost number is a valid number
    time_left = block_check.validate_time(time[0], hash_calc)
    return "Line #{line}: Time stamp contains a non-numeric value: #{original}" if time_left.nil?

    # see if rightmost number is a valid number
    time_right = block_check.validate_time(time[1], hash_calc)
    return "Line #{line}: Time stamp contains a non-numeric value: #{original}" if time_right.nil?

    # comparing left time to previous time
    if time_left == previous_left_time
      if time_right <= previous_right_time
        return "Line #{line}: Previous timestamp #{previous_left_time}.#{previous_right_time}"\
               " >= new timestamp #{original}"
      end
    elsif time_left < previous_left_time
      return "Line #{line}: Previous timestamp #{previous_left_time}.#{previous_right_time}"\
             " >= new timestamp #{original}"
    end
    [time_left, time_right]
  end
end
