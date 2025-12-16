input = File.readlines(ARGV[0]).map { |line| line.strip.chars }

beams = Set.new
splits = 0

(0..(input.length - 1)).each do |y|
  if y == 0
    beams << input[y].index("S")
    next
  end

  (0..(input[0].length - 1)).each do |x|
    c = input[y][x]

    if c == "^" && beams.include?(x)
      # Split beam
      splits += 1
      beams -= [x]
      beams += [x - 1, x + 1]
    end
  end
end

puts splits
