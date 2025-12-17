require_relative "minimum_integer_solution"

input = File.readlines(ARGV[0]).map { |line|
  inputs = line.strip.split(" ")
  joltages = inputs[-1][1..-2].split(",").map(&:to_i)
  buttons = inputs[1..-2].map { |button| button[1..-2].split(",").map(&:to_i) }
  [joltages, buttons]
}
puts input.inspect

OFF = "."
ON = "#"

def press_buttons(buttons, number_of_presses_per_button, joltages_length)
  joltages = [0] * joltages_length
  number_of_presses_per_button.each_with_index { |press_count, i|
    joltage_indexes = buttons[i]
    joltage_indexes.each { |j| joltages[j] += press_count }
  }
  joltages
  # puts "press_buttons(#{button_presses}, #{number_of_buttons})"
  # joltages = [0] * number_of_buttons
  # button_presses.each do |buttons|
  #   buttons.each do |button|
  #     joltages[button] += 1
  #   end
  # end
  # joltages
end

result_sum = input.sum do |joltages, buttons|
  # joltages = input[0][0]
  # buttons = input[0][1]

  puts "\n#Evaluating #{joltages}, #{buttons}"

  # (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
  # This represents a system of equations, AX = B
  # A - the button inputs
  # X - the unknown numbers of presses
  # B - the joltage outputs
  # This becomes,
  # | 0 0 0 0 1 1 |   | x1 |   | 3 |
  # | 0 1 0 0 0 1 | * | x2 | = | 5 |
  # | 0 0 1 1 1 0 |   | x3 |   | 4 |
  # | 1 1 0 1 0 0 |   | x4 |   | 7 |
  #                   | x5 |
  #                   | x6 |

  # a = Numo::DFloat[
  #   [0, 0, 0, 0, 1, 1],
  #   [0, 1, 0, 0, 0, 1],
  #   [0, 0, 1, 1, 1, 0],
  #   [1, 1, 0, 1, 0, 0]
  # ]

  a = Numo::DFloat.zeros(joltages.length, buttons.length)

  buttons.each_with_index { |button, i|
    button.each { |b|
      a[b, i] = 1
    }
  }

  # puts a.inspect
  # return
  # Define the constants vector b
  # b = Numo::DFloat[3, 5, 4, 7]
  b = Numo::DFloat[*joltages]

  result = Float::INFINITY
  results = nil
  search_range = 10
  until result != Float::INFINITY
    if search_range != 10
      puts "Increased search range to #{search_range}"
    end
    if search_range > 200
      puts "Unable to find solution for Ax = b"
      puts a.inspect
      puts b.inspect
      return
    end
    results = find_minimum_integer_solution(a, b, search_range: -search_range..search_range)
    result = results[1]
    search_range += 10
  end

  puts results.inspect
  puts results[1]
  puts results[1].class
  results[1]
end

puts "result_sum"
puts result_sum

# first_joltage = joltages[0]

# # All possible ranges of presses that could result in that joltage
# first_joltage_button_indexes = buttons.map.with_index { |button, i| i if button.include?(0) }.compact
# # This is the range that the number of presses for these buttons need to fall within
# first_joltage_range = (0..first_joltage)

# puts "Button indexes #{first_joltage_button_indexes} control joltage 0, with range #{first_joltage_range}"
# puts "This means, the number of button presses of #{buttons.slice(*first_joltage_button_indexes)} must sum to #{first_joltage}"

# puts "Solutions for joltage 0 = #{joltages[0]}"
# number_of_contributing_buttons = first_joltage_button_indexes.length
# max_presses = first_joltage

# second_joltage_button_indexes = buttons.map.with_index { |button, i| i if button.include?(1) }.compact
# second_joltage_range = (0..joltages[1])
# puts "Button indexes #{second_joltage_button_indexes} control joltage 1, with range #{second_joltage_range}"

# third_joltage_button_indexes = buttons.map.with_index { |button, i| i if button.include?(2) }.compact
# third_joltage_range = (0..joltages[2])
# puts "Button indexes #{third_joltage_button_indexes} control joltage 2, with range #{third_joltage_range}"

# fourth_joltage_button_indexes = buttons.map.with_index { |button, i| i if button.include?(3) }.compact
# fourth_joltage_range = (0..joltages[3])
# puts "Button indexes #{fourth_joltage_button_indexes} control joltage 3, with range #{fourth_joltage_range}"

# # Which joltages require button 0?
# # These required joltages define the range of solutions for button 0
# joltage_button_indexes = [
#   first_joltage_button_indexes,
#   second_joltage_button_indexes,
#   third_joltage_button_indexes,
#   fourth_joltage_button_indexes
# ]
# joltages_requiring_button = (0..5).map { |i| joltage_button_indexes.select { |x| x.include?(i) } }

# puts "joltages_requiring_button"
# joltages_requiring_button.each_with_index { |j, i| puts "#{i} - #{j}" }

# Next, group the ranges per button
# button_ranges = (0..(buttons.length - 1)).each_with_object({}) { |b, acc|
#   acc[b] = [
#     (first_joltage_range if first_joltage_button_indexes.include?(b)),
#     (second_joltage_range if second_joltage_button_indexes.include?(b)),
#     (third_joltage_range if third_joltage_button_indexes.include?(b)),
#     (fourth_joltage_range if fourth_joltage_button_indexes.include?(b))
#   ]
# }
# button_ranges = {
#   0 => [
#     (first_joltage_range if first_joltage_button_indexes.include?(0)),
#     (second_joltage_range if second_joltage_button_indexes.include?(0)),
#     (third_joltage_range if third_joltage_button_indexes.include?(0)),
#     (fourth_joltage_range if fourth_joltage_button_indexes.include?(0))
#   ]
# }

# puts button_ranges.inspect

return
# Attempt 2
# i = 0
# result_sum = input.sum do |joltages, buttons|
#   i += 1
#   puts "\n#{i} - Evaluating #{joltages}, #{buttons}"

#   initial_solution_candidate = [0] * buttons.length
#   solution_candidates = [initial_solution_candidate]
#   puts "Solution candidates: #{solution_candidates}"
#   solution_found = false
#   number_of_presses = 0
#   until solution_found
#     number_of_presses += 1
#     puts "\n N: #{number_of_presses} - looking for #{joltages}"
#     next_solution_candidates = []
#     solution_candidates.each do |number_of_presses_per_button|
#       # puts "number_of_presses_per_button #{number_of_presses_per_button}"
#       # button_presses = button_press_indexes.map { |n| buttons[n] }
#       result = press_buttons(buttons, number_of_presses_per_button, joltages.length)
#       # result = press_buttons(button_presses, joltages.length)
#       # puts "Result of (#{number_of_presses_per_button}) is #{result}"
#       if result == joltages
#         "Solution found!"
#         solution_found = true
#         break
#       elsif result.zip(joltages).all? { |a, b| a <= b }
#         # puts "No solution yet, but still viable"
#         # If this solution is still viable, add set of next button presses to candidates

#         next_solution_candidates += (0..(buttons.length - 1)).map do |b|
#           new_solution = [*number_of_presses_per_button]
#           new_solution[b] += 1
#           new_solution
#         end
#       else
#         # puts "No solution for #{number_of_presses_per_button}"
#       end
#     end

#     solution_candidates = next_solution_candidates

#     break if number_of_presses > 11
#   end

#   puts "Solution found using #{number_of_presses} button presses"
#   # number_of_presses
#   break number_of_presses
# end

# Attempt 1
# i = 0
# result_sum = input.sum do |joltages, buttons|
#   i += 1
#   puts "#{i} - Evaluating #{joltages}, #{buttons}"

#   solution_found = false
#   number_of_presses = 0
#   until solution_found
#     number_of_presses += 1
#     # puts "Testing #{number_of_presses} button presses..."
#     buttons.repeated_combination(number_of_presses) do |button_presses|
#       result = press_buttons(button_presses, joltages.length)
#       # puts "Result of #{button_presses} is #{result}"
#       if result == joltages
#         # "Solution found!"
#         solution_found = true
#         break
#       end
#     end
#     # break if number_of_presses > 10
#   end

#   puts "Solution found using #{number_of_presses} button presses"
#   # number_of_presses
#   break number_of_presses
# end

# puts result_sum
