#require 'simplecov'
#SimpleCov.start

require 'minitest/autorun'
require_relative './accounts.rb'

# Class used to test Accounts class
class AccountsTest < Minitest::Test
  def setup
    @g = Accounts.new
    @g.add_account("test")
    @g.add_account("test2")
    @g.add_balance("test2", 5)
    @g.add_account("test3")
    @g.add_balance("test3", 10)
  end

  # UNIT TESTS FOR METHOD add_account(x)
  # method just for code coverage, nothing to test

  # Testing adding account to hash
  def test_add_account
    assert_equal 0, @g.add_account( "name")
  end

  # UNIT TESTS FOR METHOD add_balance(x,y)

  # Testing adding balance to account
  def test_add_balance
    assert_equal 5, @g.add_balance("test", 5)
  end

  # Testing adding balance to account
  def test_add_balanace_two
    assert_equal 7, @g.add_balance("test2", 2)
  end

  # UNIT TESTS FOR METHOD remove_balance(x,y)

  # Testing removing balance from account
  def test_remove_balance
    assert_equal -5, @g.remove_balance("test", 5)
  end

  # Testing removing balance to account
  def test_remove_balanace_two
    assert_equal 8, @g.remove_balance("test3", 2)
  end

  # UNIT TESTS FOR METHOD account_exists?(x)

  # Testing account that exists
  def test_account_exists_true
    assert_equal true, @g.account_exists?("test2")
  end

  # Testing account that doesn't exists
  def test_account_exists_false
    assert_equal false, @g.account_exists?("name")
  end

  # UNIT TESTS FOR METHOD negative_balance?

  # Testing negative balance when account negative
  def test_negative_balance_true
    @g.add_account("test4")
    @g.remove_balance("test4", 4)
    assert_equal ["test4", -4], @g.negative_balance?
  end

  # Testing negative balance when no account negative
  def test_negative_balance_false
    assert_nil @g.negative_balance?
  end
end
