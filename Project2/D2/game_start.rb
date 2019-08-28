# class used to run actual game
class GameStart
  attr_reader :turns
  def initialize(iterations)
    raise 'Iterations must be an integer!' unless iterations.is_a? Integer
    raise 'iterations cannot be less than or equal to 0!' if iterations <= 0

    @turns = iterations
  end

  # make this method get called once per prospector
  def round(rubyist_num, location_arr, num_gen, game_func)
    raise 'rubyist_num must be an integer!' unless rubyist_num.is_a? Integer

    raise 'rubyist_num cannot be less than or equal to 0!' if rubyist_num <= 0

    index = 0 # used to hold current location prospector is in
    iteration = 1 # used to keep counter for current iteration
    total_rubies = 0       # used to keep track of how many real rubies prospector found
    total_fake = 0         # used to keep track of how many fake rubies prospector found
    game_func.new_rubyist_display(rubyist_num, location_arr)
    while iteration <= @turns # repeat until out of iterations
      continue = true # only set to false when no rubies found in a location
      while iteration <= @turns && continue # repeat until leaving location or iterations over
        # get the number of rubies found at a location for this day
        found_rubies = []
        found_rubies[0] = game_func.rubie_number(location_arr.max_ruby(index), num_gen)
        found_rubies[1] = game_func.rubie_number(location_arr.max_fakes(index), num_gen)
        iteration += 1 # advance the day
        total_rubies += found_rubies[0] # used to keep track of total found rubies for a prospector
        total_fake += found_rubies[1]
        # used to keep tray if we should move on or not
        continue = false if found_rubies[0].zero? && found_rubies[1].zero?
        game_func.day_output(found_rubies, index, location_arr)
      end
      if iteration <= @turns
        old_index = index
        index = game_func.new_location(index, num_gen, location_arr)
        game_func.location_change(location_arr, old_index, index)
      end
    end
    # after searching for x number of days display results:
    game_func.display_rubies(total_rubies, total_fake, rubyist_num, @turns)
    game_func.results(total_rubies)
  end
end
