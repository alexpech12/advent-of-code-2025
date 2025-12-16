input = File.readlines(ARGV[0]).map { |line| line.strip.chars }

beams_at_x = {}

(0..(input.length - 1)).each do |y|
  if y == 0
    start_index = input[y].index("S")
    beams_at_x[start_index] = 1
    next
  end

  (0..(input[0].length - 1)).each do |x|
    c = input[y][x]

    if c == "^"
      beam_count = beams_at_x[x]
      next if beam_count.nil?

      beams_at_x[x - 1] ||= 0
      beams_at_x[x + 1] ||= 0
      beams_at_x[x - 1] += beam_count
      beams_at_x[x + 1] += beam_count
      beams_at_x[x] = 0
    end
  end
end

puts beams_at_x.inspect
puts beams_at_x.values.sum
