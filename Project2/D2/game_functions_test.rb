require 'minitest/autorun'
require_relative './game_functions.rb'

# Class used to test GameFunctions class
class GameFunctionsTest < Minitest::Test
  def setup
    @g = GameFunctions.new()
  end

  # UNIT TESTS FOR METHOD display_rubies(w, x, y, z)
  # Equivalence classes:
  # w = 0..INFINITY, x = 0..INFINITY, and y = 1..INFINITY, z = 1..INFINITY -> displays valid string output
  # w = -INFINITY..-1 -> raises an error
  # x = -INFINITY..-1 -> raises an error
  # y = -INFIINTY..0 -> raises an error
  # z = -INFINITY..0-> raises an error
  # w = 1, x = 1, y = 1..INFINITY, z = 2..INFINITY -> displayed strings include "days", "ruby", and "fake ruby"
  # w = 0,2..INFINITY, x = 0,2..INFINITY, y = 1..INFINITY, z = 2..INFINITY -> displayed strings include "days", "rubies",and "fake rubies"
  # w = 0..INFINITY, x = 0..INFINITY,y = 1..INFINITY, z = 1 -> displayed strings should include "day"

 # If 1 is given for w, 1 is given for x, 1 is given for y, and 2 is given for z, then the output
 # should be as stated below.
 # Tests to see if when 1 ruby, 1 fake ruby, and 2 days, string correcltly output with "ruby" instead of "rubies".
  def test_display_one
    assert_output("After 2 days, Rubyist #1 found:\n\t1 ruby.\n\t1 fake ruby.\n") { @g.display_rubies(1, 1, 1, 2) }
  end

  # If 2 is given for w, 2 is given for x, 2 is given for y, and 2 is given for z, then the output
  # should be as stated below.
  # Tests to see if when 2 rubies, 2 fake rubies, and 2 days, string correcltly output with "rubies" instead of "ruby".
  def test_display_two
    assert_output("After 2 days, Rubyist #2 found:\n\t2 rubies.\n\t2 fake rubies.\n") { @g.display_rubies(2, 2, 2, 2) }
  end

  # If 1 is given for w, 1 is given for x, 1 is given for y, and 1 is given for z, then the output
  # should be as stated below.
  # Tests to see if when 1 day, output says "day" and not "days".
  def test_display_one_day
    assert_output("After 1 day, Rubyist #1 found:\n\t1 ruby.\n\t1 fake ruby.\n") { @g.display_rubies(1, 1, 1, 1) }
  end

  # If -1 is given for w, 1 is given for x, 1 is given for y, and 2 is given for z, then an error
  # should be raised.
  # Tests to see if given invalid w, the program raises an error.
  def test_display_negative_real
    assert_raises("total_rubies must be a number greater than or equal to 0.\n") { @g.display_rubies(-1, 1, 1, 2) }
  end

  # If 1 is given for w, -1 is given for x, 1 is given for y, and 2 is given for z, then an error
  # should be raised.
  # Tests to see if given invalid x, the program raises an error.
  def test_display_negative_fake
    assert_raises('total_fakes must be greater than or equal to 0!\n') { @g.display_rubies(1, -1, 1, 2) }
  end

  # If 1 is given for w, 1 is given for x, 0 is given for y, and 2 is given for z, then an error
  # should be raised.
  # Tests to see if given invalid y, the program raises an error.
  def test_display_negative_rubyist
    assert_raises('rubyist_num must be greater than 0!\n') { @g.display_rubies(1, 1, 0, 2) }
  end

  # If 1 is given for w, 1 is given for x, 0 is given for y, and 0 is given for z, then an error
  # should be raised.
  # Tests to see if given invalid z, the program raises an error.
  def test_display_negative_iterations
    assert_raises('rubyist_num must be greater than 0!\n') { @g.display_rubies(1, 1, 1, 0) }
  end

  # If a is given for w, 1 is given for x, 1 is given for y, and 2 is given for z, then an error
  # should be raised.
  # Tests to see if given a string to w, the program raises an error.
  # EDGE CASE
  def test_display_invalid_real
    assert_raises('total_rubies must be an integer!') { @g.display_rubies('a', 1, 1, 2) }
  end

  # If 1 is given for w, a is given for x, 1 is given for y, and 2 is given for z, then an error
  # should be raised.
  # Tests to see if given a string to x, the program raises an error.
  # EDGE CASE
  def test_display_invalid_fake
    assert_raises('total_fake rubies must be an integer!') { @g.display_rubies(1, 'a', 1, 2) }
  end

  # If 1 is given for w, 1 is given for x, a is given for y, and 2 is given for z, then an error
  # should be raised.
  # Tests to see if given a string to y, the program raises an error.
  # EDGE CASE
  def test_display_invalid_ruby
    assert_raises('rubyist_num must be an integer!') { @g.display_rubies(1, 1, 'a', 2) }
  end

  # UNIT TESTS FOR METHOD new_location(x, y, z)
  # Equivalence classes:
  # x = -INFINITY..-1 -> raises an error
  # x = 0..6 -> returns a integer
  # x = 7..INFINITY -> raises an error

  # If 0 is given for x, assumming y and z are valid objects, should return an integer 2.
  def test_new_location_mock_zero
    random = Minitest::Mock.new("test_random")
    def random.rand(num); 5; end
    location = Minitest::Mock.new("test_location_arr")
    def location.neighbor_count(index); 0; end
    def location.find_neighbor(index, new_index); 2; end
    assert_equal 2, @g.new_location(0, random, location)
  end

  # If 6 is given for x, assuming x and z are valid objects, should return an integer 4.
  def test_new_location_mock_high_bound
    random = Minitest::Mock.new("test_random")
    def random.rand(num); 0; end
    location = Minitest::Mock.new("test_location_arr")
    def location.neighbor_count(index); 2; end
    def location.find_neighbor(index, new_index); 4; end
    assert_equal 4, @g.new_location(6, random, location)
  end

  # If 7 is given for x, then a error should be raised.
  def test_new_location_high
    random = Minitest::Mock.new("test_random")
    location = Minitest::Mock.new("test_location_arr")
    assert_raises('Invalid index!') { @g.new_location(7, random, location) }
  end

  # If -1 is given for x, then an error should be raised.
  def test_new_location_low
    random = Minitest::Mock.new("test_random")
    location = Minitest::Mock.new("test_location_arr")
    assert_raises('Invalid Index!') { @g.new_location(-1, random, location) }
  end

  # If a is given for x, then an error should be raised.
  #EDGE CASE
  def test_new_location_invalid
    random = Minitest::Mock.new("test_random")
    location = Minitest::Mock.new("test_location_arr")
    assert_raises('Index must be an integer!') { @g.new_location('a', random, location) }
  end

  # UNIT TESTS FOR METHOD rubie_number(x, y)
  # Equivalence classes:
  # x = -INFINITY..-1 -> raises an error
  # x = 0 -> returns 0
  # x = 1..3 -> returns a integer between 0 and x
  # x = 4..INFINITY -> raises an error

  # If 0 is given for x, then 0 should be returned.
  def test_rubie_number_zero
    random = Minitest::Mock.new("test_random")
    assert_equal 0, @g.rubie_number(0, random)
  end

  # If 3 is given for x, then 2 should be returned.
  def test_rubie_number_valid
    random = Minitest::Mock.new("test_random")
    def random.rand(num); 2; end
    assert_equal 2, @g.rubie_number(3, random)
  end

  # If -1 is given for x, then an error should be raised.
  def test_rubie_number_negative
    random = Minitest::Mock.new("test_random")
    assert_raises('max1 cannot be less than 0!') { @g.rubie_number(-1, random) }
  end

  # If 4 is given for x, then an error should be raised.
  def test_rubie_number_high
    random = Minitest::Mock.new("test_random")
    assert_raises('max1 cannot be greater than 3 for any location!') { @g.rubie_number(4, random) }
  end

  # If b is given for x, then an error should be raised.
  # EDGE CASE
  def test_rubie_number_invalid
    random = Minitest::Mock.new("test_random")
    assert_raises('max1 must be an integer!') { @g.rubie_number('b', random) }
  end

  # UNIT TESTS FOR METHOD results(x)
  # Equivalence classes:
  # x = -INFINITY..-1 -> raises an error
  # x = 0 -> outputs "Going home empty-handed."
  # x = 1..9 -> outputs "Going home sad."
  # x = 10..INFINITY -> outputs "Going home victorious!"

  # If 10 is given for x, then "Going home victorious!" should be output.
  def test_results_victory
    assert_output("Going home victorious!\n") { @g.results(10) }
  end

  # If 9 is given for x, then "Going home sad." should be output.
  def test_results_sad
    assert_output("Going home sad.\n") { @g.results(9) }
  end

  # If 1 is given for x, then "Going home sad." should be output.
  def test_results_sad_one
    assert_output("Going home sad.\n") { @g.results(1) }
  end

  # If 0 is given for x, then "Going home empty-handed." should be output.
  def test_results_zero
    assert_output("Going home empty-handed.\n") { @g.results(0) }
  end

  # If -1 is given for x, then an error should be raised.
  def test_results_negative
    assert_raises('Cannot have a negative number of rubies found!') { @g.results(-1) }
  end

  # If a is given for x, then an error should be raised.
  # EDGE CASE
  def test_results_invalid
    assert_raises('rubies_found must be an integer!') { @g.results('a') }
  end

  # UNIT TESTS FOR METHOD day_output(x,y,z)
  # Equivalence classes:
  # x = [-INFINITY..-1,-INFINITY..-1] -> raise an error
  # x = [0..INFINITY, 0..INFINITY] -> displays correct output.
  # x = array with size greater or less than 2 -> raise an error
  # y = -INFINITY..-1 -> raises an error
  # y = 0..6 -> execution continues
  # y = 7..INFINITY -> raises an error

  # Tests if given -1 values for the x array, then an error is raised.
  def test_day_output_negative_rubies
    location = Minitest::Mock.new("test_location_arr")
    assert_raises('Cannot have a negative number of rubies found!') { @g.day_output([-1, -1], 0, location) }
  end

  # Tests if -1 is given for y, an error is raised.
  def test_day_output_negative_location
    location = Minitest::Mock.new("test_location_arr")
    assert_raises('Invalid index!') { @g.day_output([1, 1], -1, location) }
  end

  # Tests if 7 is given for y, then an error is raised.
  def test_day_output_high_location
    location = Minitest::Mock.new("test_location_arr")
    assert_raises('Invalid index!') { @g.day_output([1, 1], 7, location) }
  end

  # Tests if a string is given for y, an error is raised.
  # EDGE CASE
  def test_day_output_string_location
    location = Minitest::Mock.new("test_location_arr")
    assert_raises('Index must be a integer!') { @g.day_output([1, 1], 'matt', location) }
  end

  # Tests if a string is given for the first index of the array for x, an error is raised.
  # EDGE CASE
  def test_day_output_string_rubies_one
    location = Minitest::Mock.new("test_location_arr")
    assert_raises('Must pass in 2 integers for found_rubies!') { @g.day_output(['M', 1], 1, location) }
  end

  # Tests if a string is given for the second index of the array for x, then an error is raised.
  # EDGE CASE
  def test_day_output_string_rubies_two
    location = Minitest::Mock.new("test_location_arr")
    assert_raises('Must pass in 2 integers for found_rubies!') { @g.day_output([1, 'A'], 1, location) }
  end

  # Tests if more than array size bigger than 2 for x, an error is raised.
  # EDGE CASE
  def test_day_output_too_many
    location = Minitest::Mock.new("test_location_arr")
    assert_raises('found_rubies should only contain 2 integers!') { @g.day_output([2, 3, 4], 1, location) }
  end

  # Tests if [0,0] is given for x, then the string below should be output.
  # "\tFound no rubies or no fake rubies in Enumerable Canyon.\n"
  def test_day_output_zero
    location = Minitest::Mock.new("test_location_arr")
    def location.get_id(index); "Enumerable Canyon"; end
    assert_output("\tFound no rubies or no fake rubies in Enumerable Canyon.\n") { @g.day_output([0, 0], 3, location) }
  end

  # Tests if the array [1,1] is given for x, then the string below should be output.
  # "\tFound 1 ruby and 1 fake ruby in Nil Town.\n"
  def test_day_output_one
    location = Minitest::Mock.new("test_location_arr")
    def location.get_id(index); "Nil Town"; end
    assert_output("\tFound 1 ruby and 1 fake ruby in Nil Town.\n") { @g.day_output([1, 1], 3, location) }
  end

  # Tests if the array [1,0] is given for x, then the string below shold be output.
  # "\tFound 1 ruby in Monkey Patch City.\n"
  def test_day_output_one_real
    location = Minitest::Mock.new("test_location_arr")
    def location.get_id(index); "Monkey Patch City"; end
    assert_output("\tFound 1 ruby in Monkey Patch City.\n") { @g.day_output([1, 0], 3, location) }
  end

  # Tests if [0,1] is given for x, then the string below should be output.
  # "\tFound 1 fake ruby in Dynamic Palisades.\n"
  def test_day_output_one_fake
    location = Minitest::Mock.new("test_location_arr")
    def location.get_id(index); "Dynamic Palisades"; end
    assert_output("\tFound 1 fake ruby in Dynamic Palisades.\n") { @g.day_output([0, 1], 3, location) }
  end

  # Tests if [2,0] is given for x, then the string below should be output.
  # "\tFound 2 rubies in Hash Crossing.\n"
  def test_day_output_several_real
    location = Minitest::Mock.new("test_location_arr")
    def location.get_id(index); "Hash Crossing"; end
    assert_output("\tFound 2 rubies in Hash Crossing.\n") { @g.day_output([2, 0], 3, location) }
  end

  # Tests if [0,2] is given for x, then the string below should be output.
  # "\tFound 2 fake rubies in Duck Type Beach.\n"
  def test_day_output_several_fakes
    location = Minitest::Mock.new("test_location_arr")
    def location.get_id(index); "Duck Type Beach"; end
    assert_output("\tFound 2 fake rubies in Duck Type Beach.\n") { @g.day_output([0, 2], 3, location) }
  end

  # Tests if [2,2] is given for x, then the string below should be output.
  # "\tFound 2 rubies and 2 fake rubies in Matzburg.\n"
  def test_day_output_several_both
    location = Minitest::Mock.new("test_location_arr")
    def location.get_id(index); "Matzburg"; end
    assert_output("\tFound 2 rubies and 2 fake rubies in Matzburg.\n") { @g.day_output([2, 2], 3, location) }
  end

  # UNIT TESTS FOR METHOD new_rubyist_display(x,y)
  # Equivalence classes:
  # x = -INFINITY..0 -> raise an error
  # x = 1..INFINITY -> displays correct output

  # Tests if given 1 for x, then the string below is output.
  # "Rubyist #1 starting in Hash Crossing.\n"
  def test_rubyist_display
    location = Minitest::Mock.new("test_location_arr")
    def location.get_id(index); "Hash Crossing"; end
    assert_output("Rubyist #1 starting in Hash Crossing.\n") { @g.new_rubyist_display(1, location) }
  end

  # Tests if a is given for x, then an error is raised
  # EDGE CASE
  def test_rubyist_display_string
    location = Minitest::Mock.new("test_location_arr")
    def location.get_id(index); "Hash Crossing"; end
    assert_raises('rubyist_num must be an intenger!') { @g.new_rubyist_display('a', location) }
  end

  # Tests if 0 is given for x, then an error is raised
  def test_rubyist_display_zero
    location = Minitest::Mock.new("test_location_arr")
    def location.get_id(index); "Hash Crossing"; end
    assert_raises('rubyist_num cannot be less than or equal to 0!') { @g.new_rubyist_display(0, location) }
  end

  # UNIT TESTS FOR METHOD location_change(x,y,z)
  # Equivalence classes:
  # y = -INFINITY..-1 -> raise an error
  # y = 0..6 -> execution continues
  # y = 7..INFINITY-> raise an error
  # z = -INFINITY..-1 -> raise an error
  # z = 0..6 -> execution continues
  # z = 7..INFINITY-> raise an error

  # If 0 is given for y and 0 is given for z, then the string below should be displayed.
  # "Heading from Hash Crossing to Hash Crossing.\n"
  def test_location_change
    location = Minitest::Mock.new("test_location_arr")
    def location.get_id(index); "Hash Crossing"; end
    assert_output("Heading from Hash Crossing to Hash Crossing.\n") { @g.location_change(location, 0, 0)}
  end

  # If a is given for y, then an error should be raised.
  # EDGE CASE
  def test_location_change_string_old
    location = Minitest::Mock.new("test_location_arr")
    def location.get_id(index); "Hash Crossing"; end
    assert_raises('old_index must be an integer!') { @g.location_change(location, 'a', 1)}
  end

  # If a is given for z, then an error should be raised.
  # EDGE CASE
  def test_location_change_string_new
    location = Minitest::Mock.new("test_location_arr")
    def location.get_id(index); "Hash Crossing"; end
    assert_raises('index must be an integer!') { @g.location_change(location, 0, 'a')}
  end

  # If -1 is given for y, then an error should be raised.
  def test_location_change_invalid_old
    location = Minitest::Mock.new("test_location_arr")
    def location.get_id(index); "Hash Crossing"; end
    assert_raises('Invalid old index!') { @g.location_change(location, -1 , 1)}
  end

  # If 7 is given for y, then an error should be raised.
  def test_location_change_invalid_new
    location = Minitest::Mock.new("test_location_arr")
    def location.get_id(index); "Hash Crossing"; end
    assert_raises('Invalid index!') { @g.location_change(location, 0, 7)}
  end
end
