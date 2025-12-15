input = File.readlines(ARGV[0]).map(&:strip).map(&:chars)

input.each { |row| puts row.inspect }

def count_surrounds(grid, x, y)
  points = [
    [x - 1, y],
    [x - 1, y - 1],
    [x, y - 1],
    [x + 1, y - 1],
    [x + 1, y],
    [x + 1, y + 1],
    [x, y + 1],
    [x - 1, y + 1]
  ]
  points.count do |(x, y)|
    # puts "Testing adjacent point #{x}, #{y}"
    next false if x < 0 || y < 0 || x >= grid[0].length || y >= grid.length
    # puts "VALID! - #{grid[y][x]}"
    grid[y][x] == "@"
  end
end

result = 0
no_more_results = false
until no_more_results
  results_this_iteration = 0
  (0..(input.length - 1)).each do |y|
    (0..(input[0].length - 1)).each do |x|
      # puts "testing point #{x}, #{y} - #{input[y][x]} #{count_surrounds(input, x, y)}"
      if input[y][x] == "@" && count_surrounds(input, x, y) < 4
        results_this_iteration += 1
        input[y][x] = "x"
      end
    end
  end
  result += results_this_iteration
  no_more_results = true if results_this_iteration == 0
end

puts result
