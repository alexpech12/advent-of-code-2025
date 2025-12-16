input = File.readlines(ARGV[0]).map { |l| l.strip.split(",").map(&:to_i) }

max_area = input.combination(2).map { |a, b|
  x = (a[0] - b[0]).abs + 1
  y = (a[1] - b[1]).abs + 1
  (x * y).abs
}.max

puts max_area
