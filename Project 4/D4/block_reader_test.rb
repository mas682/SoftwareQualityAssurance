#require 'simplecov'
#SimpleCov.start

require 'minitest/autorun'
require_relative './blockreader.rb'

# Class used to test BlockReader class
class BlockReaderTest < Minitest::Test
  def setup
    @g = BlockReader.new
  end

  # UNIT TESTS FOR METHOD transactions(w,x,y,z)

  # Testing output if transaction string is empty
  def test_transactions_no_transactions
    account_tracker = Minitest::Mock.new('test_account_tracker')
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.parse(string, char); []; end
    output = "Line 0: Cannot have 0 or less transactions \'\'"
    assert_equal output, @g.transactions( '', account_tracker, block_checker, 0)
  end

  # Testing output if transaction string does not have > in it
  def test_transactions_no_arrow
    account_tracker = Minitest::Mock.new('test_account_tracker')
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.parse(string, char); ["1"]; end
    output = "Line 0: Could not parse transactions list \'abcd\'"
    assert_equal output, @g.transactions( 'abcd', account_tracker, block_checker, 0)
  end

  # Testing output if transaction string does not have ) in it
  def test_transactions_no_arrow
    account_tracker = Minitest::Mock.new('test_account_tracker')
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.parse(string, char); ["1", "2"]; end
    def block_checker.check_last_char(string, char); false; end
    output = "Line 0: Last character of transaction must be ')': \'1\'"
    assert_equal output, @g.transactions( '123456>123456(2)a', account_tracker, block_checker, 0)
  end

  # Testing output if transaction string does not have ( in it
  def test_transactions_no_paren
    account_tracker = Minitest::Mock.new('test_account_tracker')
    block_checker = Minitest::Mock.new('test_block_checker')
    block_checker.expect(:parse, ["123456>123456(2)"], ["123456>123456(2)", ":"])
    block_checker.expect(:parse, ["123456", "123456(2)"], ["123456>123456(2)", ">"])
    block_checker.expect(:parse, ["123456"], ["123456(2)", "("])
    def block_checker.check_last_char(string, char); nil; end
    output = "Line 0: Too many or too few '(' in transaction 1: \'123456>123456(2)\'"
    assert_equal output, @g.transactions( '123456>123456(2)', account_tracker, block_checker, 0)
  end

  # Testing output if transaction leftmost account only 5 digits
  def test_transactions_small_first
    account_tracker = Minitest::Mock.new('test_account_tracker')
    block_checker = Minitest::Mock.new('test_block_checker')
    block_checker.expect(:parse, ["123456>123456(2)"], ["123456>123456(2)", ":"])
    block_checker.expect(:parse, ["12345", "123456(2)"], ["123456>123456(2)", ">"])
    block_checker.expect(:parse, ["123456", "2)"], ["123456(2)", "("])
    def block_checker.check_last_char(string, char); nil; end
    output = "Line 0: Account number \'12345\' has a invalid length"
    assert_equal output, @g.transactions( '123456>123456(2)', account_tracker, block_checker, 0)
  end

  # Testing output if transaction rightmost account only 5 digits
  def test_transactions_small_second
    account_tracker = Minitest::Mock.new('test_account_tracker')
    block_checker = Minitest::Mock.new('test_block_checker')
    block_checker.expect(:parse, ["123456>123456(2)"], ["123456>123456(2)", ":"])
    block_checker.expect(:parse, ["123456", "123456(2)"], ["123456>123456(2)", ">"])
    block_checker.expect(:parse, ["12345", "2)"], ["123456(2)", "("])
    def block_checker.check_last_char(string, char); nil; end
    output = "Line 0: Account number \'12345\' has a invalid length"
    assert_equal output, @g.transactions( '123456>123456(2)', account_tracker, block_checker, 0)
  end

  # Testing output if transaction leftmost account has a char in it
  def test_transactions_char_first
    account_tracker = Minitest::Mock.new('test_account_tracker')
    block_checker = Minitest::Mock.new('test_block_checker')
    block_checker.expect(:parse, ["12345a>123456(2)"], ["12345a>123456(2)", ":"])
    block_checker.expect(:parse, ["12345a", "123456(2)"], ["12345a>123456(2)", ">"])
    block_checker.expect(:parse, ["123456", "2)"], ["123456(2)", "("])
    block_checker.expect(:check_digits, nil, ["12345a"])
    def block_checker.check_last_char(string, char); nil; end
    output = "Line 0: Transaction 1 contains a non-numeric value \'12345a\'"
    assert_equal output, @g.transactions( '12345a>123456(2)', account_tracker, block_checker, 0)
  end

  # Testing output if transaction rightmost account has a char in it
  def test_transactions_char_second
    account_tracker = Minitest::Mock.new('test_account_tracker')
    block_checker = Minitest::Mock.new('test_block_checker')
    block_checker.expect(:parse, ["123456>12345a(2)"], ["123456>12345a(2)", ":"])
    block_checker.expect(:parse, ["123456", "12345a(2)"], ["123456>12345a(2)", ">"])
    block_checker.expect(:parse, ["12345a", "2)"], ["12345a(2)", "("])
    block_checker.expect(:check_digits, true, ["123456"])
    block_checker.expect(:check_digits, nil, ["12345a"])
    def block_checker.check_last_char(string, char); nil; end
    output = "Line 0: Transaction 1 contains a non-numeric value \'12345a\'"
    assert_equal output, @g.transactions( '123456>12345a(2)', account_tracker, block_checker, 0)
  end

  # Testing output if first block has more than one transaction
  def test_transactions_multiple_first
    account_tracker = Minitest::Mock.new('test_account_tracker')
    block_checker = Minitest::Mock.new('test_block_checker')
    block_checker.expect(:parse, ["123456>123456(2)", "abcdefg"], ["123456>123456(2):abcdefg", ":"])
    block_checker.expect(:parse, ["123456", "123456(2)"], ["123456>123456(2)", ">"])
    block_checker.expect(:parse, ["123456", "2)"], ["123456(2)", "("])
    block_checker.expect(:check_digits, true, ["123456"])
    block_checker.expect(:check_digits, true, ["123456"])
    def block_checker.check_last_char(string, char); nil; end
    output = "Line 0: Line 0 can only have one transaction: \'123456>123456(2):abcdefg\'"
    assert_equal output, @g.transactions( '123456>123456(2):abcdefg', account_tracker, block_checker, 0)
  end

  # Testing output if transaction for first block not from SYSTEM
  def test_transactions_not_system
    account_tracker = Minitest::Mock.new('test_account_tracker')
    block_checker = Minitest::Mock.new('test_block_checker')
    block_checker.expect(:parse, ["123456>123456(a)"], ["123456>123456(a)", ":"])
    block_checker.expect(:parse, ["123456", "123456(a)"], ["123456>123456(a)", ">"])
    block_checker.expect(:parse, ["123456", "a)"], ["123456(a)", "("])
    block_checker.expect(:check_digits, true, ["123456"])
    block_checker.expect(:check_digits, true, ["123456"])
    block_checker.expect(:get_coins, "ab", ["123456(a)"])
    def block_checker.check_last_char(string, char); nil; end
    output = "Line 0: Line 0 can only have a transaction from the system: \'123456>123456(a)\'"
    assert_equal output, @g.transactions( '123456>123456(a)', account_tracker, block_checker, 0)
  end

  # Testing output if two ) given for the number of coins
  def test_transactions_two_paren
    account_tracker = Minitest::Mock.new('test_account_tracker')
    block_checker = Minitest::Mock.new('test_block_checker')
    block_checker.expect(:parse, ["SYSTEM>123456(a)"], ["SYSTEM>123456(a)", ":"])
    block_checker.expect(:parse, ["SYSTEM", "123456(a)"], ["SYSTEM>123456(a)", ">"])
    block_checker.expect(:parse, ["123456", "a)"], ["123456(a)", "("])
    block_checker.expect(:check_digits, true, ["123456"])
    block_checker.expect(:get_coins, "ab", ["123456(a)"])
    def block_checker.check_last_char(string, char); nil; end
    output = "Line 0: Invalid coin format for transaction 1: \'SYSTEM>123456(a)\'"
    assert_equal output, @g.transactions( 'SYSTEM>123456(a)', account_tracker, block_checker, 0)
  end

  # Testing output if a char given for the number of coins
  def test_transactions_char_coins
    account_tracker = Minitest::Mock.new('test_account_tracker')
    block_checker = Minitest::Mock.new('test_block_checker')
    block_checker.expect(:parse, ["SYSTEM>123456(a)"], ["SYSTEM>123456(a)", ":"])
    block_checker.expect(:parse, ["SYSTEM", "123456(a)"], ["SYSTEM>123456(a)", ">"])
    block_checker.expect(:parse, ["123456", "a)"], ["123456(a)", "("])
    block_checker.expect(:check_digits, true, ["123456"])
    block_checker.expect(:get_coins, "a", ["123456(a)"])
    def block_checker.check_coins(string); nil; end
    def block_checker.check_last_char(string, char); nil; end
    output = "Line 0: Invalid coin format for transaction 1: \'SYSTEM>123456(a)\'"
    assert_equal output, @g.transactions( 'SYSTEM>123456(a)', account_tracker, block_checker, 0)
  end

  # Testing output if transaction from system and coins not 100
  def test_transactions_system_coin
    account_tracker = Minitest::Mock.new('test_account_tracker')
    block_checker = Minitest::Mock.new('test_block_checker')
    block_checker.expect(:parse, ["SYSTEM>123456(1)"], ["SYSTEM>123456(1)", ":"])
    block_checker.expect(:parse, ["SYSTEM", "123456(1)"], ["SYSTEM>123456(1)", ">"])
    block_checker.expect(:parse, ["123456", "1)"], ["123456(1)", "("])
    block_checker.expect(:check_digits, true, ["123456"])
    block_checker.expect(:get_coins, "1", ["123456(1)"])
    def block_checker.check_coins(string); true; end
    def block_checker.check_last_char(string, char); nil; end
    output = "Line 0: Invalid coin format from system for transaction 1 \'SYSTEM>123456(1)\'"
    assert_equal output, @g.transactions( 'SYSTEM>123456(1)', account_tracker, block_checker, 0)
  end

  # Testing output if not last transaction and from transaction system
  def test_transactions_system_coin
    account_tracker = Minitest::Mock.new('test_account_tracker')
    block_checker = Minitest::Mock.new('test_block_checker')
    block_checker.expect(:parse, ["SYSTEM>123456(100)", "456"], ["SYSTEM>123456(100):456", ":"])
    block_checker.expect(:parse, ["SYSTEM", "123456(100)"], ["SYSTEM>123456(100)", ">"])
    block_checker.expect(:parse, ["123456", "100)"], ["123456(100)", "("])
    block_checker.expect(:check_digits, true, ["123456"])
    block_checker.expect(:get_coins, "100", ["123456(100)"])
    def block_checker.check_coins(string); 100; end
    def block_checker.check_last_char(string, char); nil; end
    output = "Line 1: The last transaction may only be from the system: \'SYSTEM>123456(100):456\'"
    assert_equal output, @g.transactions( 'SYSTEM>123456(100):456', account_tracker, block_checker, 1)
  end

  # Testing output if at last transaction and not from system
  def test_transactions_system_not_last
    account_tracker = Minitest::Mock.new('test_account_tracker')
    block_checker = Minitest::Mock.new('test_block_checker')
    block_checker.expect(:parse, ["123457>123456(100)"], ["123457>123456(100)", ":"])
    block_checker.expect(:parse, ["123457", "123456(100)"], ["123457>123456(100)", ">"])
    block_checker.expect(:parse, ["123456", "100)"], ["123456(100)", "("])
    block_checker.expect(:check_digits, true, ["123457"])
    block_checker.expect(:check_digits, true, ["123456"])
    block_checker.expect(:get_coins, "100", ["123456(100)"])
    def block_checker.check_coins(string); 100; end
    def block_checker.check_last_char(string, char); nil; end
    output = "Line 1: The last transaction may only be from the system: \'123457>123456(100)\'"
    assert_equal output, @g.transactions( '123457>123456(100)', account_tracker, block_checker, 1)
  end

  # Testing output if there is a negative account
  def test_transactions_negative_bal
    account_tracker = Minitest::Mock.new('test_account_tracker')
    block_checker = Minitest::Mock.new('test_block_checker')
    block_checker.expect(:parse, ["SYSTEM>123456(100)"], ["SYSTEM>123456(100)", ":"])
    block_checker.expect(:parse, ["SYSTEM", "123456(100)"], ["SYSTEM>123456(100)", ">"])
    block_checker.expect(:parse, ["123456", "100)"], ["123456(100)", "("])
    block_checker.expect(:check_digits, true, ["123456"])
    block_checker.expect(:get_coins, "100", ["123456(100)"])
    def block_checker.check_coins(string); 100; end
    def block_checker.check_last_char(string, char); nil; end
    block_checker.expect(:add_account, 1, [account_tracker, "123456", 100])
    def account_tracker.negative_balance?; ["1", -1]; end
    output = "Line 1: Invalid block, address 1 has -1 billcoins!"
    assert_equal output, @g.transactions( 'SYSTEM>123456(100)', account_tracker, block_checker, 1)
  end

  # Testing output if everything passes
  def test_transactions_negative_bal_false
    account_tracker = Minitest::Mock.new('test_account_tracker')
    block_checker = Minitest::Mock.new('test_block_checker')
    block_checker.expect(:parse, ["SYSTEM>123456(100)"], ["SYSTEM>123456(100)", ":"])
    block_checker.expect(:parse, ["SYSTEM", "123456(100)"], ["SYSTEM>123456(100)", ">"])
    block_checker.expect(:parse, ["123456", "100)"], ["123456(100)", "("])
    block_checker.expect(:check_digits, true, ["123456"])
    block_checker.expect(:get_coins, "100", ["123456(100)"])
    def block_checker.check_coins(string); 100; end
    def block_checker.check_last_char(string, char); nil; end
    block_checker.expect(:add_account, 1, [account_tracker, "123456", 100])
    def account_tracker.negative_balance?; nil; end
    assert_nil @g.transactions( 'SYSTEM>123456(100)', account_tracker, block_checker, 1)
  end

  # UNIT TESTS FOR METHOD block_num(w,x,y,z)
  # Equivalence classes
  # w contains a non-numeric value after a numeric value
  # w contains only a single non-numeric value
  # w contains a value that is not equal to z
  # w and z are equal

  # Testing output if block number contains a non numeric value with a numeric value first
  def test_block_num_char_and_num
    hash_calc = Minitest::Mock.new('test_hash_calculator')
    block_checker = Minitest::Mock.new('test_block_checker')
    output = "Line 0: Invalid block number 0a, should be 0\nNon-numeric value detected"
    assert_equal output, @g.block_num( '0a', hash_calc, block_checker, 0)
  end

  # Testing output if a single char is given for block number, kind of a corner case wehre to_i returns 0
  def test_block_num_char
    hash_calc = Minitest::Mock.new('test_hash_calculator')
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.verify_zero(num, hash_calc); false; end
    output = "Line 0: Invalid block number a, should be 0\nNon-numeric value detected"
    assert_equal output, @g.block_num( 'a', hash_calc, block_checker, 0)
  end

  # Testing output if block number does not equal the value that it should
  def test_block_num_invalid
    hash_calc = Minitest::Mock.new('test_hash_calculator')
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.check_block_num(line, num); false; end
    output = "Line 0: Invalid block number 1, should be 0"
    assert_equal output, @g.block_num( '1', hash_calc, block_checker, 0)
  end

  # Testing output if block number is correct
  def test_block_num_valid
    hash_calc = Minitest::Mock.new('test_hash_calculator')
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.check_block_num(line, num); true; end
    assert_nil @g.block_num( '1', hash_calc, block_checker, 1)
  end

  # UNIT TESTS FOR METHOD previous_hash(w,x,y,z)
  # Equivalence classes
  # size of x is greater than or equal to 5
  # w has a size of 4 or less with a 0 in the first index
  # w has a non hex value in it
  # w has a capital hex letter in it
  # w is not equal to x
  # w is equal to x

  # Testing output if number of characters in previous hash 5 or greater
  def test_previous_hash_too_big
    block_checker = Minitest::Mock.new('test_block_checker')
    output = "Line 0: Previous hash was 12345, should be 2710\nLenght of previous hash too long"
    assert_equal output, @g.previous_hash( '12345', 10000, block_checker, 0)
  end

  # Testing output if hash has a leading 0
  def test_previous_hash_zero
    block_checker = Minitest::Mock.new('test_block_checker')
    output = "Line 0: Previous hash was 0123, should be 2710\nCannot have leading 0's in previous hash"
    assert_equal output, @g.previous_hash( '0123', 10000, block_checker, 0)
  end

  # Testing output if hash has a non hex value in it
  def test_previous_hash_non_hex
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.check_hex(string); false; end
    output = "Line 0: Previous hash was 112g, should be 2710\nInvalid hex value, must be lowercase and from 0-f"
    assert_equal output, @g.previous_hash( '112g', 10000, block_checker, 0)
  end

  # Testing output if hash has a capital hex value in it
  def test_previous_hash_capital
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.check_hex(string); false; end
    output = "Line 0: Previous hash was 112F, should be 2710\nInvalid hex value, must be lowercase and from 0-f"
    assert_equal output, @g.previous_hash( '112F', 10000, block_checker, 0)
  end

  # Testing output if actual previous hash and hash stored in string do not match
  def test_previous_hash_not_equal
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.check_hex(string); true; end
    def block_checker.check_hash(actual, stored); false; end
    output = "Line 0: Previous hash was 1234, should be 2710"
    assert_equal output, @g.previous_hash( '1234', 10000, block_checker, 0)
  end

  # Testing output if hashes match
  def test_previous_hash_equal
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.check_hex(string); true; end
    def block_checker.check_hash(actual, stored); true; end
    assert_nil @g.previous_hash( '2710', 10000, block_checker, 0)
  end

  # UNIT TESTS FOR METHOD hash(v,w,x,y,z)
  # Equivalence classes
  # w has a more than 4 characters
  # w has a 0 at first index
  # w contains a non hex value
  # w is not equal to actual hash
  # w is the correct hash value

  # Testing output if lenght of hash greater than 4
  def test_hash_long
    hash_calc = Minitest::Mock.new('test_hash_calculator')
    block_checker = Minitest::Mock.new('test_block_checker')
    block = '0|abc|1234>1234(4)|1213.34123|1234'
    output = "Line 0: Invalid hash set to 12345\nHash length is too big"
    assert_equal output, @g.hash( block, '12345', hash_calc, block_checker, 0)
  end

  # Testing output if hash has a leading 0
  def test_hash_zero
    hash_calc = Minitest::Mock.new('test_hash_calculator')
    block_checker = Minitest::Mock.new('test_block_checker')
    block = '0|abc|1234>1234(4)|1213.34123|1234'
    output = "Line 0: Invalid hash set to 0123\nHash contains leading zeros"
    assert_equal output, @g.hash( block, '0123', hash_calc, block_checker, 0)
  end

  # Testing output if hash has a non-hex character
  def test_hash_zero
    hash_calc = Minitest::Mock.new('test_hash_calculator')
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.check_hex(string); false; end
    block = '0|abc|1234>1234(4)|1213.34123|1234'
    output = "Line 0: Invalid hash set to 212g\nInvalid hex value, must be lowercase and from 0-f"
    assert_equal output, @g.hash( block, '212g', hash_calc, block_checker, 0)
  end

  # Testing output if hash is invalid
  def test_hash_invalid_hash
    hash_calc = Minitest::Mock.new('test_hash_calculator')
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.check_hex(string); true; end
    def block_checker.get_hash(block, hash_calc); 11000; end
    def block_checker.check_hash(actual, stored); false; end
    def block_checker.parse(block, char); ['0|abc|1234>1234(4)|1213.34123']; end
    block = '0|abc|1234>1234(4)|1213.34123|1234'
    output = "Line 0: String '0|abc|1234>1234(4)|1213.34123' hash set to 1234,should be 2af8"
    assert_equal output, @g.hash( block, '1234', hash_calc, block_checker, 0)
  end

  # Testing output if hash correct
  def test_hash_valid_hash
    hash_calc = Minitest::Mock.new('test_hash_calculator')
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.check_hex(string); true; end
    def block_checker.get_hash(block, hash_calc); 11000; end
    def block_checker.check_hash(actual, stored); true; end
    def block_checker.parse(block, char); ['0|abc|1234>1234(4)|1213.34123']; end
    block = '0|abc|1234>1234(4)|1213.34123|1234'
    output = "Line 0: String '0|abc|1234>1234(4)|1213.34123' hash set to 1234,should be 2af8"
    assert_nil @g.hash( block, '1234', hash_calc, block_checker, 0)
  end

  # UNIT TESTS FOR METHOD time_stamp(v,w,x,y,z)
  # Equivalence classes
  # v has a period at the end
  # v is missing a period
  # v cotains a char in leftmost part
  # v contains a char in rightmost part
  # v contains a value in rightmost half that is less than previous value
  # v contains value in leftmost half that is less than previous value
  # v is in the correct format


  # Testing output if timestampe ends in .
  def test_time_stamp_period_end
    hash_calc = Minitest::Mock.new('test_hash_calculator')
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.parse(block, char); ['3456', '2335']; end
    time_arr = [1234, 5678]
    output = "Line 0: Time stamp cannot end in '.': 3456.2345."
    assert_equal output, @g.time_stamp( '3456.2345.', time_arr, hash_calc, block_checker, 0)
  end

  # Testing output if timestampe is missing .
  def test_time_stamp_period_end
    hash_calc = Minitest::Mock.new('test_hash_calculator')
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.parse(block, char); ['34562345']; end
    time_arr = [1234, 5678]
    output = "Line 0: Time stamp has too few or too many '.': 34562345"
    assert_equal output, @g.time_stamp( '34562345', time_arr, hash_calc, block_checker, 0)
  end

  # Testing output if timestampe has a char in left half
  def test_time_stamp_left_char
    hash_calc = Minitest::Mock.new('test_hash_calculator')
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.parse(block, char); ['345a','2345']; end
    block_checker.expect(:validate_time, nil, ["345a", hash_calc])
    time_arr = [1234, 5678]
    output = "Line 0: Time stamp contains a non-numeric value: 345a.2345"
    assert_equal output, @g.time_stamp( '345a.2345', time_arr, hash_calc, block_checker, 0)
  end

  # Testing output if timestamp has a char in right half
  def test_time_stamp_right_char
    hash_calc = Minitest::Mock.new('test_hash_calculator')
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.parse(block, char); ['3456','234a']; end
    block_checker.expect(:validate_time, 3456, ["3456", hash_calc])
        block_checker.expect(:validate_time, nil, ["234a", hash_calc])
    time_arr = [1234, 5678]
    output = "Line 0: Time stamp contains a non-numeric value: 3456.234a"
    assert_equal output, @g.time_stamp( '3456.234a', time_arr, hash_calc, block_checker, 0)
  end

  # Testing output if left time correct, but right time less than previous
  def test_time_stamp_right_low
    hash_calc = Minitest::Mock.new('test_hash_calculator')
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.parse(block, char); ['3456','2349']; end
    block_checker.expect(:validate_time, 3456, ["3456", hash_calc])
    block_checker.expect(:validate_time, 2349, ["2349", hash_calc])
    time_arr = [3456, 2350]
    output = "Line 0: Previous timestamp 3456.2350 >= new timestamp 3456.2349"
    assert_equal output, @g.time_stamp( '3456.2349', time_arr, hash_calc, block_checker, 0)
  end

  # Testing output if left time less than previous time
  def test_time_stamp_left_low
    hash_calc = Minitest::Mock.new('test_hash_calculator')
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.parse(block, char); ['3456','2349']; end
    block_checker.expect(:validate_time, 3456, ["3456", hash_calc])
    block_checker.expect(:validate_time, 2349, ["2349", hash_calc])
    time_arr = [5000, 2350]
    output = "Line 0: Previous timestamp 5000.2350 >= new timestamp 3456.2349"
    assert_equal output, @g.time_stamp( '3456.2349', time_arr, hash_calc, block_checker, 0)
  end

  # Testing output if time correct
  def test_time_stamp_correct
    hash_calc = Minitest::Mock.new('test_hash_calculator')
    block_checker = Minitest::Mock.new('test_block_checker')
    def block_checker.parse(block, char); ['3456','2349']; end
    block_checker.expect(:validate_time, 3456, ["3456", hash_calc])
    block_checker.expect(:validate_time, 2349, ["2349", hash_calc])
    time_arr = [3456, 2330]
    assert_equal [3456, 2349], @g.time_stamp( '3456.2349', time_arr, hash_calc, block_checker, 0)
  end

  # UNIT TESTS FOR METHOD read_file(v,w,x,y,z)
  # Equivalence classes

  # Testing output at end of file
  def test_read_file
    hash_calc = Minitest::Mock.new('test_hash_calculator')
    block_checker = Minitest::Mock.new('test_block_checker')
    account_tracker = Minitest::Mock.new('account_tracker')
    def block_checker.read_next_line; nil; end
    def account_tracker.print_accounts; nil; end
    assert_nil @g.read_file(hash_calc, block_checker, account_tracker)
  end

  # Testing output at too many blocks in a line
  def test_read_file_many_blocks
    hash_calc = Minitest::Mock.new('test_hash_calculator')
    block_checker = Minitest::Mock.new('test_block_checker')
    account_tracker = Minitest::Mock.new('account_tracker')
    def block_checker.read_next_line; "1|2|3|4|5|6"; end
    def block_checker.parse(string, char); ["1","2","3","4","5","6"]; end
    output = "Line 0: Too many '|' in the block '1|2|3|4|5|6'"
    assert_equal output, @g.read_file(hash_calc, block_checker, account_tracker)
  end

end
