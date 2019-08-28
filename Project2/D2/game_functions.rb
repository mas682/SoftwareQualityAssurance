# class used to run actual game
class GameFunctions
  # generate two random numbers to use for number of rubies a user found
  def rubie_number(max1, num_gen)
    raise 'max1 must be an integer!' unless max1.is_a? Integer

    raise 'max1 cannot be less than 0!' if max1 < 0

    raise 'max1 cannot be greater than 3 for any location!' if max1 >= 4

    if max1 > 0 && max1 <= 3
      num_gen.rand(max1 + 1)
    else
      0
    end
  end

  def new_rubyist_display(rubyist_num, location_arr)
    raise 'rubyist_num must be an integer!' unless rubyist_num.is_a? Integer
    raise 'rubyist_num cannot be less than or equal to 0!' if rubyist_num <= 0

    puts "Rubyist ##{rubyist_num} starting in #{location_arr.get_id(0)}."
  end

  def location_change(location_arr, old_index, index)
    raise 'old_index must be an integer!' unless old_index.is_a? Integer
    raise 'index must be an integer!' unless index.is_a? Integer
    raise 'Invalid index!' if index < 0 || index >= 7
    raise 'Invalid old_index!' if old_index < 0 || old_index >= 7

    puts "Heading from #{location_arr.get_id(old_index)} to #{location_arr.get_id(index)}." # output where going to
  end

  # used to find a new location to go to

  def new_location(index, num_gen, location_arr)
    raise 'Index must be an integer!' unless index.is_a? Integer
    raise 'Invalid index!' if index < 0 || index > 6

    array_ind = num_gen.rand(location_arr.neighbor_count(index))
    index = location_arr.find_neighbor(index, array_ind)
    index
  end

  # used to display exact number of rubies found_rubies
  def display_rubies(total_rubies, total_fake, rubyist_num, iterations)
    raise 'total_rubies must be an integer!' unless total_rubies.is_a? Integer

    raise 'total_fake rubies must be an integer!' unless total_fake.is_a? Integer

    raise 'rubyist_num must be an integer!' unless rubyist_num.is_a? Integer

    raise 'total_rubies must be a number greater than or equal to 0.' if total_rubies < 0

    raise 'total_fakes must be greater than or equal to 0!' if total_fake < 0

    raise 'rubyist_num must be greater than 0!' if rubyist_num <= 0

    raise 'Iterations must be an integer!' unless iterations.is_a? Integer

    raise 'iterations cannot be less than or equal to 0!' if iterations <= 0

    if iterations == 1
      puts "After #{iterations} day, Rubyist ##{rubyist_num} found:"
    else
      puts "After #{iterations} days, Rubyist ##{rubyist_num} found:"
    end
    if total_rubies == 1
      puts "\t#{total_rubies} ruby."
    else
      puts "\t#{total_rubies} rubies."
    end
    if total_fake == 1
      puts "\t#{total_fake} fake ruby."
    else
      puts "\t#{total_fake} fake rubies."
    end
  end

  # used to display results for one given days
  def day_output(found_rubies, index, location_arr)
    raise 'Must pass in 2 integers for found_rubies!' unless (found_rubies[0].is_a? Integer) ||
                                                             (found_rubies[1].is_a? Integer)

    raise 'Cannot have a negative number of rubies found!' if found_rubies[0] < 0 || found_rubies[1] < 0

    raise 'found_rubies should only contain 2 integers!' if found_rubies.count != 2

    raise 'Index must be a integer!' unless index.is_a? Integer
    raise 'Invalid index!' if index < 0 || index >= 7

    if found_rubies[0].zero? && found_rubies[1].zero?
      puts "\tFound no rubies or no fake rubies in #{location_arr.get_id(index)}."
    elsif found_rubies[0] == 1 && found_rubies[1] == 1 # found 1 of each
      puts "\tFound #{found_rubies[0]} ruby and #{found_rubies[1]} fake ruby in"\
           " #{location_arr.get_id(index)}."
    elsif found_rubies[1].zero? && found_rubies[0] == 1 # found 1 real, 0 fakes
      puts "\tFound #{found_rubies[0]} ruby in #{location_arr.get_id(index)}."
    elsif found_rubies[0].zero? && found_rubies[1] == 1 # found 1 fake, 0 real
      puts "\tFound #{found_rubies[1]} fake ruby in #{location_arr.get_id(index)}."
    elsif found_rubies[1].zero? && found_rubies[0] > 1 # found 0 fake, several real
      puts "\tFound #{found_rubies[0]} rubies in #{location_arr.get_id(index)}."
    elsif found_rubies[0].zero? && found_rubies[1] > 1 # found 0 real, several fake
      puts "\tFound #{found_rubies[1]} fake rubies in #{location_arr.get_id(index)}."
    else # found several real and several fakes
      puts "\tFound #{found_rubies[0]} rubies and #{found_rubies[1]} fake rubies in"\
           " #{location_arr.get_id(index)}."
    end
  end

  # used to display results given however many rubies found
  def results(rubies_found)
    raise 'rubies_found must be an integer!' unless rubies_found.is_a? Integer

    raise 'Cannot have a negative number of rubies found!' if rubies_found < 0

    if rubies_found >= 10
      puts 'Going home victorious!'
    elsif rubies_found >= 1 && rubies_found < 10
      puts 'Going home sad.'
    else
      puts 'Going home empty-handed.'
    end
  end
end
