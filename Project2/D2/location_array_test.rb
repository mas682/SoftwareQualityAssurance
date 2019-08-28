require 'minitest/autorun'
require_relative './location_array.rb'
# Class to test the class LocationArray.
class LocationArrayTest < Minitest::Test
  def setup
    @g = LocationArray.new
  end

  # UNIT TESTS FOR METHOD neighbor_count(x)
  # Equivalence classes:
  # x= -INFINITY..-1 -> raises an error
  # x= 0..6 -> returns an integer
  # x= 7..INFINITY -> raises an error

  # If 0 is given for x, then a integer should be returned.
  # Tests lower limit for x.
  def test_neighbor_count_valid_low
    assert_instance_of Integer, @g.neighbor_count(0)
  end

  # If 6 is given for x, then a integer should be returned.
  # Tests upper limit for x.
  def test_neighbor_count_valid_high
    assert_instance_of Integer, @g.neighbor_count(6)
  end

  # If -1 is given for x, a error should be raised.
  # Tests lower limit for x.
  def test_neighbor_count_negative
    assert_raises ('Index out of valid range!') { @g.neighbor_count(-1) }
  end

  # If 7 is given for x, a error should be raised.
  # Tests upper limit for x.
  def test_neighbor_count_high
    assert_raises ('Index out of valid range!') { @g.neighbor_count(7) }
  end

  # UNIT TESTS FOR METHOD find_neighbor(x,y)
  # Equivalence classes:
  # x= -INFINITY..-1 -> raises an error
  # y= -INFINITY..-1 -> raises an error
  # x= 0..6 and y = 0..3 -> returns an integer
  # x= 7..INFINITY -> raises an error
  # y= 4..INFINITY -> raises an error

  # If 0 is given for x and 0 is given for y, then a integer should be returned.
  # Tests lower limits for x and y.
  def test_find_neighbor_valid_low
    assert_instance_of Integer, @g.find_neighbor(0,0)
  end

  # If 2 is given for x and 3 is given for y, then a integer should be returned.
  # Tests upper limit for y.
  def test_find_neighbor_valid_high_new
    assert_instance_of Integer, @g.find_neighbor(2,3)
  end

  # If 6 is given for x and 0 is given for y, then a integer should be returned.
  # Tests upper limit for x.
  def test_find_neighbor_valid_high_old
    assert_instance_of Integer, @g.find_neighbor(6, 0)
  end

  # If 7 is given for x and 3 is given for y, then a error should be raises.
  # Tests upper limit for x.
  def test_find_nighbor_high_old
    assert_raises ('Index out of valid range!') { @g.find_neighbor(7,3)}
  end

  # If 4 is given for x and 4 is given for y, then a error should be raises.
  # Tests upper limit for y.
  def test_find_nighbor_high_new
    assert_raises ('Index out of valid range!') { @g.find_neighbor(4,4)}
  end

  # If 0 is given for x and -1 is given for y, then an error should be raised.
  # Tests lower limit for y.
  def test_find_nighbor_low_new
    assert_raises ('New index out of valid range!') { @g.find_neighbor(0, -1)}
  end

  # If -1 is given for x and 2 is given for y, then an error should be raised.
  # Tests lower limit for x.
  def test_find_nighbor_low_old
    assert_raises ('New index out of valid range!') { @g.find_neighbor(-1, 2)}
  end

  # UNIT TESTS FOR METHOD get_id(x)
  # Equivalence classes:
  # x= -INFINITY..-1 -> raises an error
  # x= 0..6 -> returns an String
  # x= 7..INFINITY -> raises an error

  # If 0 is given for x, a String should be returned.
  # Tests lower limit for x.
  def test_get_id_valid_low
    assert_instance_of String, @g.get_id(0)
  end

  # If 6 is given for x, a String should be returned.
  # Tests upper limit for x.
  def test_get_id_valid_high
    assert_instance_of String, @g.get_id(6)
  end

  # If -1 is given for x, then a error should be raised.
  # Tests lower limit for x.
  def test_get_id_negative
    assert_raises ('Index out of valid range!') { @g.get_id(-1) }
  end

  # If 7 is given for x, then a error should be raised.
  # Tests upper limit for x.
  def test_get_id_high
    assert_raises ('Index out of valid range!') { @g.get_id(7) }
  end

  # UNIT TESTS FOR METHOD max_ruby(x)
  # Equivalence classes:
  # x= -INFINITY..-1 -> raises an error
  # x= 0..6 -> returns an integer
  # x= 7..INFINITY -> raises an error

  # If 0 is given for x and 0 is given for y, then a integer should be returned.
  # Tests lower limits for x and y.
  def test_max_ruby_valid_low
    assert_instance_of Integer, @g.max_ruby(0)
  end

  # If 6 is given for x, then a integer should be returned.
  # Tests upper limit for x.
  def test_max_ruby_valid_high
    assert_instance_of Integer, @g.max_ruby(6)
  end

  # If -1 is given for x, a error should be raised.
  # Tests lower limit for x.
  def test_max_ruby_negative
    assert_raises ('Index out of valid range!') { @g.max_ruby(-1) }
  end

  # If 7 is given for x, a error should be raised.
  # Tests upper limit for x.
  def test_max_ruby_high
    assert_raises ('Index out of valid range!') { @g.max_ruby(7) }
  end

  # UNIT TESTS FOR METHOD max_fakes(x)
  # Equivalence classes:
  # x= -INFINITY..-1 -> raises an error
  # x= 0..6 -> returns an integer
  # x= 7..INFINITY -> raises an error

  # If 0 is given for x and 0 is given for y, then a integer should be returned.
  # Tests lower limits for x and y.
  def test_max_fakes_valid_low
    assert_instance_of Integer, @g.max_fakes(0)
  end

  # If 6 is given for x, then a integer should be returned.
  # Tests upper limit for x.
  def test_max_fakes_valid_high
    assert_instance_of Integer, @g.max_fakes(6)
  end

  # If -1 is given for x, a error should be raised.
  # Tests lower limit for x.
  def test_max_fakes_negative
    assert_raises ('Index out of valid range!') { @g.max_fakes(-1) }
  end

  # If 7 is given for x, a error should be raised.
  # Tests upper limit for x.
  def test_max_fakes_high
    assert_raises ('Index out of valid range!') { @g.max_fakes(7) }
  end
end
