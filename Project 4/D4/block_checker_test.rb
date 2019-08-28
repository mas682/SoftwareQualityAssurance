#require 'simplecov'
#SimpleCov.start

require 'minitest/autorun'
require_relative './blockchecker.rb'

# Class used to test BlockChecker class
class BlockCheckerTest < Minitest::Test
  def setup
    file = File.open('INIT.txt', 'r') # open the file that was passed as a argument
    @g = BlockChecker.new(file)
  end

  # UNIT TESTS FOR METHOD check_hash(x,y)
  # Equivalence classes:
  # x and y are equal integers -> retuns true
  # x and y are not equal integers -> retuns false

  # If 1 is given for x and  1 is given for y, then the method should output true
  def test_check_hash_equal
    assert_equal true, @g.check_hash(1, 1)
  end

  # If 1 is given for x and 0 is given for y, then the method should output false
  def test_check_hash_unequal
    assert_equal false, @g.check_hash(1, 0)
  end

  # UNIT TESTS FOR METHOD check_block_num(x,y)
  # Equivalence classes:
  # x and y are equal integers -> returns true
  # x and y are not equal integers -> returns nil

  # If 1 is given for x and  1 is given for y, then the method should output true
  def test_check_block_num_equal
    assert_equal true, @g.check_block_num(1, 1)
  end

  # If 1 is given for x and 0 is given for y, then the method should output false
  def test_check_block_num_unequal
    assert_nil nil, @g.check_block_num(1, 0)
  end

  # UNIT TESTS FOR METHOD check_capital(x)
  # Equivalence classes:
  # x is a string with a capial letter in it -> returns nil
  # x is a string without a capital letter in it -> returns true

  # If "abDc" is given for x, then the method should return nil
  def test_check_capital_contains
    assert_nil @g.check_capital('abDc')
  end

  # If "abdc" is given for x, then the method should return true
  def test_check_capital_false
    assert_equal true, @g.check_capital('abdc')
  end

  # If "abcD" is given for x, then the method should return nil
  # checking to make sure last character checked for capital letter
  def test_check_capital_end
    assert_nil @g.check_capital('abcD')
  end

  # If "?!.(3" is given for x, then the method should return true
  # checking non-alphaabetic characters
  def test_check_capital_non_alpha
  assert_equal true, @g.check_capital('?!.(3')
  end

  # UNIT TESTS FOR METHOD check_hex(x)
  # Equivalence classes:
  # x is a string with a capial only hex digits in it in lowercase -> returns true
  # x is a string with a non hex digit in it -> returns nil
  # x is a string with a capital hex digit in it -> return nil

  # If "01ef" is given for x, then the method should return true
  def test_check_hex_true
    assert_equal true, @g.check_hex('01ef')
  end

  # If "01efg" is given for x, then the method should return nil
  # checks to see if g or larger not allowed
  def test_check_hex_upper_bound
    assert_nil @g.check_hex('01efg')
  end

  # If "01Ef" is given for x, then the method should return nil
  # checks to see if a capital hex value allowed
  def test_check_hex_capital
    assert_nil @g.check_hex('01Ef')
  end

  # If "/01ef" is given for x, then the method should return nil
  # checks to see if / or lower not allowed
  # note method compares based off of UTF8 value
  def test_check_hex_lower_bound
    assert_nil @g.check_hex('/1efg')
  end

  # If ":1efg" is given for x, then the method should return nil
  # checks to see if : or larger not allowed..up to a
  def test_check_hex_upper_bound_num
    assert_nil @g.check_hex(':1efg')
  end

  # UNIT TESTS FOR METHOD check_digits(x)
  # Equivalence classes:
  # x is a string only digits in it -> returns true
  # x is a with at least one non-numeric character -> returns nil

  # If "0123456789" is given for x, then the method should return true
  def test_check_digits_true
    assert_equal true, @g.check_digits('0123456789')
  end

  # If "0123456789:" is given for x, then the method should return nil
  def test_check_digits_upper_bound
    assert_nil @g.check_digits('0123456789:')
  end

  # If "0123456789/" is given for x, then the method should return nil
  def test_check_digits_lower_bound
    assert_nil @g.check_digits('0123456789/')
  end

  # If "01234a6789" is given for x, then the method should return nil
  def test_check_digits_alpha
    assert_nil @g.check_digits('01234a6789')
  end

  # UNIT TESTS FOR METHOD verify_zero(x)
  # Equivalence classes:
  # x is the char "0" -> returns nil
  # x is not the char "0" -> returns 1

  # If "0" is given for x, then the method should return nil
  def test_verify_zero_true
    hash_calc = Minitest::Mock.new('test_hash_calc')
    def hash_calc.get_utf(char); [48]; end
    assert_nil @g.verify_zero('0', hash_calc)
  end

  # If "a" is given for x, then the method should return 1
  def test_check_digits_upper_bound
    hash_calc = Minitest::Mock.new('test_hash_calc')
    def hash_calc.get_utf(char); [97]; end
    assert_equal 1, @g.verify_zero('a', hash_calc)
  end

  # UNIT TESTS FOR METHOD check_last_char(x,y)
  # Equivalence classes:
  # x is a string that contains the character y at the last character -> returns nil
  # x is a string that does not contain the character y as the last character -> returns false

  # If "abc(123)" is given for x, and ')' is given for y, then the method should return nil
  def test_check_last_char_true
    assert_nil @g.check_last_char('abc(123)', ')')
  end

  # If "abc(123)" is given for x, and '3' is given for y, then the method should return false
  def test_check_last_char_false
    assert_equal false, @g.check_last_char('abc(123)', '3')
  end

  # UNIT TESTS FOR METHOD check_coins(x)
  # Equivalence classes:
  # x is a string with that holds a integer greater than 0 -> returns string as integer
  # x is a string that holds a integer less than or equal to 0 -> returns nil
  # x is a string that has non-numeric characters in it -> returns nil

  # If "1" is given for x, then the method should return 1
  def test_check_coins_true
    assert_equal 1, @g.check_coins('1')
  end

  # If '0' is given for x, then the method should return nil
  def test_check_coins_zero
    assert_nil @g.check_coins('0')
  end

  # If 'a' is given for x, then the method should return nil
  def test_check_coins_alpah
    assert_nil @g.check_coins('a')
  end

  # UNIT TESTS FOR METHOD validate_time(x, y)
  # Equivalence classes:
  # x is a string with that holds a integer greater than or equal to 0 -> returns string as integer
  # x is a string that has non-numeric characters in it -> returns nil

  # If '0' is given for x, then the method should return 0
  def test_verify_time_zero
    hash_calc = Minitest::Mock.new('test_hash_calc')
    def hash_calc.get_utf(char); [48]; end
    assert_equal 0, @g.validate_time('0', hash_calc)
  end

  # If 'a' is given for x, then nil should be returned
  def test_verify_time_alpha
    hash_calc = Minitest::Mock.new('test_hash_calc')
    def hash_calc.get_utf(char); [97]; end
    assert_nil @g.validate_time('a', hash_calc)
  end

  # If "123445" is given for x, then 123445 should be returned
  def test_verify_time_non_zero
    hash_calc = Minitest::Mock.new('test_hash_calc')
    def hash_calc.get_utf(char); [48]; end
    assert_equal 123445, @g.validate_time('123445', hash_calc)
  end

  # If '123a44' is given for x, then nil should be returned
  def test_verify_time_alpha_mid
    hash_calc = Minitest::Mock.new('test_hash_calc')
    def hash_calc.get_utf(char); [48]; end
    assert_nil @g.validate_time('123a44', hash_calc)
  end

  # UNIT TESTS FOR METHOD parse(x,y)
  # Equivalence classes:
  # x is a string with the character y in it -> returns array of strings split at character
  # x is a string wihtout the character y in it -> returns a single element array with the same string

  # If "abc:123" is given for x,and ':' is given for y then the method should return a array holding ["abc", "123"]
  def test_parse_valid
    array = @g.parse('abc:123', ':')
    assert_equal 2, array.size
    assert_equal "abc", array[0]
  end

  # If "abc:123" is given for x,and '>' is given for y then the method should return a array holding ["abc:123"]
  def test_parse_invalid
    array = @g.parse('abc:123', '>')
    assert_equal 1, array.size
    assert_equal "abc:123", array[0]
  end

  # UNIT TESTS FOR METHOD get_coins(x)
  # Equivalence classes:
  # x is a string which in the form "(xxx)"-> returns the value inside the parentheses
  # x without missing one or both parentheses -> returns nil

  # If "(ab12)" is given for x, then the method should return ab12 as a string
  def test_get_coins_valid
    assert_equal 'ab12', @g.get_coins('(ab12)')
  end

  # If "ab12" is given for x, then the method should return ab12 as a string
  def test_get_coins_invalid
    assert_nil @g.get_coins('ab12')
  end

  # UNIT TESTS FOR METHOD get_hash(x, y)
  # Equivalence classes:
  # x is a string with 4 | in it -> the hash of the string

  # this is more for code coverage, hard to test because of while loops in method
  def test_get_hash
    hash_calc = Minitest::Mock.new('test_hash_calc')
    def hash_calc.get_utf(char); [48]; end
    def hash_calc.calculate_value(num); 0; end
    def hash_calc.calculate_value_string(string); 0; end
    def hash_calc.hash_val(total); 0; end

    assert_equal 0, @g.get_hash("1|1234|123456>123456(1):456789>456789(1)|1234.12345|", hash_calc)
  end

  # UNIT TESTS FOR add_account(x, y, z)
  # Equivalence classes:
  # method just for code coverage

  def test_add_account
    mocked_account_tracker = Minitest::Mock.new("test_account_tracker")
    mocked_account_tracker.expect(:account_exists?, true, ["123456"])
    mocked_account_tracker.expect(:add_balance, 1, ["123456", 5])

    @g.add_account(mocked_account_tracker, "123456", 5)
    assert_mock mocked_account_tracker
  end

  # UNIT TESTS FOR subtract_account(x, y, z)
  # Equivalence classes:
  # method just for code coverage

  def test_subtract_account
    mocked_account_tracker = Minitest::Mock.new("test_account_tracker")
    mocked_account_tracker.expect(:account_exists?, true, ["123456"])
    mocked_account_tracker.expect(:remove_balance, 1, ["123456", 5])

    @g.subtract_account(mocked_account_tracker, "123456", 5)
    assert_mock mocked_account_tracker
  end

end
