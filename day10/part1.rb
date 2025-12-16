input = File.readlines(ARGV[0]).map { |line|
  inputs = line.strip.split(" ")
  lights = inputs[0][1..-2]
  buttons = inputs[1..-2].map { |button| button[1..-2].split(",").map(&:to_i) }
  [lights, buttons]
}
puts input.inspect

OFF = "."
ON = "#"

def press_buttons(button_presses, number_of_lights)
  puts "press_buttons(#{button_presses}, #{number_of_lights})"
  lights = OFF * number_of_lights
  button_presses.each do |buttons|
    buttons.each do |button|
      lights[button] = (lights[button] == OFF) ? ON : OFF
    end
  end
  lights
end

i = 0
result_sum = input.sum do |lights, buttons|
  i += 1
  puts "#{i} - Evaluating #{lights}, #{buttons}"

  solution_found = false
  number_of_presses = 0
  until solution_found
    number_of_presses += 1
    buttons.combination(number_of_presses) do |button_presses|
      result = press_buttons(button_presses, lights.length)
      # puts "Result of #{button_presses} is #{result}"
      if result == lights
        # "Solution found!"
        solution_found = true
        break
      end
    end
  end

  puts "Solution found using #{number_of_presses} button presses"
  number_of_presses
end

puts result_sum
