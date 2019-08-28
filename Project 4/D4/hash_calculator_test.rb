#require 'simplecov'
#SimpleCov.start

require 'minitest/autorun'
require_relative './hashcalculator.rb'

# Class used to test HashCalculator class
class HashCalculatorTest < Minitest::Test
  def setup
    @g = HashCalculator.new
  end

  # UNIT TESTS FOR METHOD get_utf(character)
  # Equivalence classes:
  # x is a single character -> retuns UTF value of character

  # If 0 is given for x, then 48 should be returned
  def test_get_utf
    assert_equal 48, @g.get_utf('0')[0]
  end

  # UNIT TESTS FOR METHOD calculate_value(x)
  # Equivalence classes:
  # x a integer between 40 and 124 -> retuns a integer

  # If 40 is given for x, then @g.table[0] should be returned
  def test_calculate_value_zero
    assert_equal @g.table[0], @g.calculate_value([40])
  end

  # if 124 is given for x, then @g.table[124] should be returned
  def test_calculate_value_max
    assert_equal @g.table[84], @g.calculate_value([124])
  end

  # if 125 is given for x, then nil should be returned
  def test_calculate_over
    assert_nil @g.calculate_value([125])
  end

  # UNIT TESTS FOR METHOD calculate_value_string(x)
  # Equivalence classes:
  # x already exists in the account table -> returns a integer
  # x does not already exist in the table -> returns a integer

  # if x does not exist, return a integer that is the same as in the table
  def test_calculate_value_string
    assert_nil @g.account_table["12345"]
    assert_equal @g.calculate_value_string("12345"), @g.account_table["12345"]
  end

  # UNIT TESTS FOR METHOD hash_val(num)

  # returns the hash of a value % 65_536
  def test_hash_val_low
    assert_equal 0, @g.hash_val(65536)
  end

  # test to make make sure returning correct value even when large
  def test_hash_val_high
    assert_equal 65535, @g.hash_val(131071)
  end

end
