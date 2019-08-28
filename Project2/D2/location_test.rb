require 'minitest/autorun'
require_relative './location.rb'

# class used to test LocationArray class
class LocationTest < Minitest::Test
  def setup
    @g = Location.new('Enumerable Canyon', ['Duck Type Beach', 'Monkey Patch City'],
                            1, 1, [1, 6])
  end

  # Testing to ensure that id of the location was set to Enumerable Canyon.
  # Just for code coverage.
  def test_id_test
    assert_equal 'Enumerable Canyon', @g.id
  end

  # Testing to esure than max_rubie was set to 1 for this location.
  # Just for code coverage.
  def test_max_rubie
    assert_equal 1, @g.max_rubie
  end

  # Testing to ensure that the neighbors were correctly set for this location.
  # Just for code coverage.
  def test_neighbors
    assert_equal ['Duck Type Beach', 'Monkey Patch City'], @g.neighbors
  end

  # Testing to ensure that max_fake_rubie was set correctly for this location.
  # Just for code coverage.
  def test_max_fake_rubie
    assert_equal 1, @g.max_fake_rubie
  end

  # Testing to ensure that num_neibors returns the number of neighbors for a location.
  def test_num_neigbors
    assert_equal 2, @g.num_neighbors
  end

  # Testing to ensure that neighbor_index gets set correctly for this location.
  # Just for code coverage.
  def test_neighbor_index
    assert_equal [1,6], @g.neighbor_index
  end

end
