require 'minitest/autorun'
require_relative './game_start.rb'
# Class used to test the class GameStart.
class GameStartTest < Minitest::Test
  def setup
    @g = GameStart.new(2)
  end

  # UNIT TESTS FOR METHOD round(v,x,y,z)
  # Equivalence classes:
  # v= -INFINITY..0 -> raises an error
  # v= 1..Infinity -> continues execution
  # x is an array of all the locations and their information.
  # y is a random number generator.
  # z is a game function object.

  # Tests if 0 is given for v, an error will be raised.
  def test_round_invalid_rubyist
    random = Minitest::Mock.new("test_random")
    def random.rand(num); 2; end

    mocked_location = Minitest::Mock.new("test_location_arr")
    def mocked_location.get_id(index); "Enumerable Canyon"; end
    def mocked_location.max_ruby(index); 0; end
    def mocked_location.max_fakes(index); 0; end

    mocked_functions = Minitest::Mock.new("mocked function")
    def mocked_functions.day_output(found, index, location); 0; end
    def mocked_functions.new_rubyist_display(value, location); 0; end
    def mocked_functions.display_rubies(total, fake, rubyist); 0; end
    def mocked_functions.results(total);0; end
    def mocked_functions.rubie_number(value, num_gen); 3; end

    assert_raises ('rubyist_num cannot be less than or equal to 0!') { @g.round(0, mocked_location, random, mocked_functions) }
  end

  # Tests to make sure the method rubie_number is called 4 times if all arguments
  # to the method round are valid.
  def test_round_assert_rubie_number
    random = Minitest::Mock.new("test_random")
    def random.rand(num); 2; end

    mocked_location = Minitest::Mock.new("test_location_arr")
    def mocked_location.get_id(index); "Enumerable Canyon"; end
    def mocked_location.max_ruby(index); 0; end
    def mocked_location.max_fakes(index); 0; end

    mocked_functions = Minitest::Mock.new("mocked function")
    def mocked_functions.day_output(found, index, location); 0; end
    def mocked_functions.new_rubyist_display(value, location); 0; end
    def mocked_functions.display_rubies(total, fake, rubyist, turns); 0; end
    def mocked_functions.results(total);0; end

    mocked_functions.expect(:rubie_number,1, [0,random])
    mocked_functions.expect(:rubie_number,1, [0,random])
    mocked_functions.expect(:rubie_number,1, [0,random])
    mocked_functions.expect(:rubie_number,1, [0,random])

    @g.round(1, mocked_location, random, mocked_functions)
    assert_mock mocked_functions # assert that whatever expectations made came true
  end

  # Tests to make sure the method day_output is called 2 times if all arguments to
  # the method round are valid.
  def test_round_assert_day_output
    random = Minitest::Mock.new("test_random")
    def random.rand(num); 2; end

    mocked_location = Minitest::Mock.new("test_location_arr")
    def mocked_location.max_ruby(index); 0; end
    def mocked_location.max_fakes(index); 0; end

    mocked_functions = Minitest::Mock.new("mocked function")
    def mocked_functions.new_rubyist_display(value, location); 0; end
    def mocked_functions.rubie_number(value, num_gen); 3; end
    def mocked_functions.display_rubies(total, fake, rubyist, turns); 0; end
    def mocked_functions.results(total);0; end

    mocked_functions.expect(:day_output,1, [[3,3], 0, mocked_location])
    mocked_functions.expect(:day_output,1, [[3,3], 0, mocked_location])

    @g.round(1, mocked_location, random, mocked_functions)
    assert_mock mocked_functions # assert that whatever expectations made came true
  end

  # Tests to make sure the method new_location is called 1 time if all arguments to
  # the method round are valid.
  def test_round_assert_new_location
    random = Minitest::Mock.new("test_random")
    def random.rand(num); 2; end

    mocked_location = Minitest::Mock.new("test_location_arr")
    def mocked_location.get_id(index); "Enumerable Canyon"; end
    def mocked_location.max_ruby(index); 0; end
    def mocked_location.max_fakes(index); 0; end

    mocked_functions = Minitest::Mock.new("mocked function")
    def mocked_functions.location_change(location, old_index, index); 0; end
    def mocked_functions.new_rubyist_display(value, location); 0; end
    def mocked_functions.rubie_number(value, num_gen); 0; end
    def mocked_functions.day_output(found, index, location); 0; end
    def mocked_functions.display_rubies(total, fake, rubyist, turns); 0; end
    def mocked_functions.results(total);0; end

    mocked_functions.expect(:new_location,1, [0, random, mocked_location])

    @g.round(1, mocked_location, random, mocked_functions)
    assert_mock mocked_functions # assert that whatever expectations made came true
  end

  # Tests to make sure the method display_rubies is called 1 time if all arguments to
  # the method round are valid.
  def test_round_assert_display_rubies
    random = Minitest::Mock.new("test_random")
    def random.rand(num); 2; end

    mocked_location = Minitest::Mock.new("test_location_arr")
    def mocked_location.max_ruby(index); 0; end
    def mocked_location.max_fakes(index); 0; end

    mocked_functions = Minitest::Mock.new("mocked function")
    def mocked_functions.new_rubyist_display(value, location); 0; end
    def mocked_functions.rubie_number(value, num_gen); 3; end
    def mocked_functions.day_output(found, index, location); 0; end
    def mocked_functions.results(total);0; end

    mocked_functions.expect(:display_rubies,1, [6, 6, 1, 2])

    @g.round(1, mocked_location, random, mocked_functions)
    assert_mock mocked_functions # assert that whatever expectations made came true
  end

  # Tests to make sure the method results is called 1 time if all arguments to
  # the method round are valid.
  def test_round_assert_results
    random = Minitest::Mock.new("test_random")
    def random.rand(num); 2; end

    mocked_location = Minitest::Mock.new("test_location_arr")
    def mocked_location.max_ruby(index); 0; end
    def mocked_location.max_fakes(index); 0; end

    mocked_functions = Minitest::Mock.new("mocked function")
    def mocked_functions.new_rubyist_display(value, location); 0; end
    def mocked_functions.rubie_number(value, num_gen); 3; end
    def mocked_functions.display_rubies(total, fake, rubyist, turns); 0; end
    def mocked_functions.day_output(found, index, location); 0; end

    mocked_functions.expect(:results,1, [6])

    @g.round(1, mocked_location, random, mocked_functions)
    assert_mock mocked_functions # assert that whatever expectations made came true
  end

  # Tests to make sure the method new_rubyist_display is called 1 time if all
  # arguments to the method round are valid.
  def test_round_assert_rubyist_display
    random = Minitest::Mock.new("test_random")
    def random.rand(num); 2; end

    mocked_location = Minitest::Mock.new("test_location_arr")
    def mocked_location.max_ruby(index); 0; end
    def mocked_location.max_fakes(index); 0; end

    mocked_functions = Minitest::Mock.new("mocked function")
    def mocked_functions.rubie_number(value, num_gen); 3; end
    def mocked_functions.display_rubies(total, fake, rubyist, turns); 0; end
    def mocked_functions.day_output(found, index, location); 0; end
    def mocked_functions.results(total);0; end

    mocked_functions.expect(:new_rubyist_display,1, [1, mocked_location])

    @g.round(1, mocked_location, random, mocked_functions)
    assert_mock mocked_functions # assert that whatever expectations made came true
  end

  # Tests to make sure the method Location_change is called 1 time if all
  # arguments to the method round are valid.
  def test_round_assert_new_location_output
    random = Minitest::Mock.new("test_random")
    def random.rand(num); 2; end

    mocked_location = Minitest::Mock.new("test_location_arr")
    def mocked_location.get_id(index); "Enumerable Canyon"; end
    def mocked_location.max_ruby(index); 0; end
    def mocked_location.max_fakes(index); 0; end

    mocked_functions = Minitest::Mock.new("mocked function")
    def mocked_functions.new_location(index, num_gen, location); 0; end
    def mocked_functions.new_rubyist_display(value, location); 0; end
    def mocked_functions.rubie_number(value, num_gen); 0; end
    def mocked_functions.day_output(found, index, location); 0; end
    def mocked_functions.display_rubies(total, fake, rubyist, turns); 0; end
    def mocked_functions.results(total);0; end

    mocked_functions.expect(:location_change,1, [mocked_location, 0, 0])

    @g.round(1, mocked_location, random, mocked_functions)
    assert_mock mocked_functions # assert that whatever expectations made came true
  end
end
