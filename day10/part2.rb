input = File.readlines(ARGV[0]).map { |line|
  inputs = line.strip.split(" ")
  joltages = inputs[-1][1..-2].split(",").map(&:to_i)
  buttons = inputs[1..-2].map { |button| button[1..-2].split(",").map(&:to_i) }
  [joltages, buttons]
}
puts input.inspect

OFF = "."
ON = "#"

def press_buttons(button_presses, number_of_buttons)
  # puts "press_buttons(#{button_presses}, #{number_of_buttons})"
  joltages = [0] * number_of_buttons
  button_presses.each do |buttons|
    buttons.each do |button|
      joltages[button] += 1
    end
  end
  joltages
end

i = 0
result_sum = input.sum do |joltages, buttons|
  i += 1
  puts "#{i} - Evaluating #{joltages}, #{buttons}"

  solution_found = false
  number_of_presses = 0
  until solution_found
    number_of_presses += 1
    # puts "Testing #{number_of_presses} button presses..."
    buttons.repeated_combination(number_of_presses) do |button_presses|
      result = press_buttons(button_presses, joltages.length)
      # puts "Result of #{button_presses} is #{result}"
      if result == joltages
        # "Solution found!"
        solution_found = true
        break
      end
    end
    # break if number_of_presses > 10
  end

  puts "Solution found using #{number_of_presses} button presses"
  number_of_presses
  # break number_of_presses
end

puts result_sum
