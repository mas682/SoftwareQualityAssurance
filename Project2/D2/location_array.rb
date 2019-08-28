require_relative './location.rb'
# class used to hold information about all locations in ruby_rush
class LocationArray
  attr_reader :locations
  def initialize
    enum_can = Location.new('Enumerable Canyon', ['Duck Type Beach', 'Monkey Patch City'],
                            1, 1, [1, 6])
    duck_beach = Location.new('Duck Type Beach', ['Enumerable Canyon', 'Matzburg'],
                              2, 2, [0, 2])
    matz = Location.new('Matzburg', ['Duck Type Beach', 'Monkey Patch City', 'Dynamic Palisades', 'Hash Crosing'],
                        3, 0, [1, 6, 3, 4])
    dyn_pal = Location.new('Dynamic Palisades', ['Hash Crossing', 'Matzburg'], 2, 2, [4, 2])
    hash_cross = Location.new('Hash Crossing', ['Dynamic Palisades', 'Matzburg', 'Nil Town'],
                              2, 2, [3, 2, 5])
    nil_town = Location.new('Nil Town', ['Hash Crossing', 'Monkey Patch City'],
                            0, 3, [4, 6])
    monkey_city = Location.new('Monkey Patch City', ['Nil Town', 'Matzburg', 'Enumerable Canyon'],
                               1, 1, [5, 2, 0])
    @locations = [enum_can, duck_beach, matz, dyn_pal, hash_cross, nil_town, monkey_city]
  end

  def neighbor_count(index)
    raise 'Index out of valid range!' if index > 6 || index < 0

    locations[index].num_neighbors
  end

  def find_neighbor(index, new_index)
    raise 'Index out of valid range!' if index > 6 || index < 0
    raise 'New index out of valid range!' if new_index > 3 || new_index < 0

    locations[index].neighbor_index[new_index]
  end

  def get_id(index)
    raise 'Index out of valid range!' if index > 6 || index < 0

    locations[index].id
  end

  def max_ruby(index)
    raise 'Index out of valid range!' if index > 6 || index < 0

    locations[index].max_rubie
  end

  def max_fakes(index)
    raise 'Index out of valid range!' if index > 6 || index < 0

    locations[index].max_fake_rubie
  end
end
