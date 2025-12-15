input = File.readlines(ARGV[0]).map { |line| line.strip.chars.map(&:to_i) }
puts input.inspect

BATTERY_COUNT = 12

result = input.sum do |batteries|
  puts batteries.join("")
  indices = []
  (0..(BATTERY_COUNT - 1)).each do |i|
    start = (indices[-1] || -1) + 1
    remaining_batteries = batteries[start..]
    number_of_batteries_to_select = BATTERY_COUNT - i
    allowed_for_next_step = remaining_batteries.length - number_of_batteries_to_select
    scoped_range = start..(start + allowed_for_next_step)
    # puts "start: #{start}, remaining: #{remaining_batteries}, num_to_select: #{number_of_batteries_to_select}, scope: #{allowed_for_next_step} #{batteries[scoped_range]}"
    max = 0
    max_index = nil
    scoped_range.each do |j|
      if batteries[j] > max
        max = batteries[j]
        max_index = j
      end
    end
    indices << max_index
    puts "#{i} - #{max} at #{max_index}"
  end
  joltage = indices.map { |i| batteries[i] }.map(&:to_s).join("").to_i
  puts "#{indices.inspect} - #{joltage}"
  joltage
end
puts result
