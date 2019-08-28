# class used to hold information about locations in ruby_rush
class Location
  attr_reader :neighbors
  attr_reader :max_rubie
  attr_reader :neighbor_index
  attr_reader :max_fake_rubie
  attr_reader :id

  def num_neighbors
    @neighbors.count
  end

  def initialize(id, neighbors, max_rubie, max_fake_rubie, neighbor_index)
    @id = id
    @neighbors = []
    neighbors.each { |n| @neighbors << n } if neighbors.count.nonzero?
    @max_rubie = max_rubie
    @max_fake_rubie = max_fake_rubie
    @neighbor_index = neighbor_index
  end
end
