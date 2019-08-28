# class to hold account balances
class Accounts
  attr_reader :accounts

  # method to initialize accounts
  # @accounts holds a accounts balance
  def initialize
    @accounts = {}
  end

  # method to create a new account, sets it to 0
  def add_account(account_num)
    @accounts[account_num] = 0
  end

  # method to add balance to an account
  def add_balance(account_num, value)
    @accounts[account_num] = @accounts[account_num] + value
  end

  # method to remove balance from an account
  def remove_balance(account_num, value)
    @accounts[account_num] = @accounts[account_num] - value
  end

  # method to see if an account exists
  def account_exists?(account_num)
    @accounts.key?(account_num)
  end

  # iterates through all accounts to see if balance is negative
  # returns array holding account and value if a balance is negative
  # otherwise returns nil
  def negative_balance?
    @accounts.each do |acc_num, val|
      return [acc_num, val] if val.negative?
    end
    nil
  end

  # method to print out accounts
  def print_accounts
    @accounts = @accounts.sort_by { |key| key }.to_h
    @accounts.each do |acc_num, val|
      puts "#{acc_num}: #{val} billcoins"
    end
    1
  end
end
