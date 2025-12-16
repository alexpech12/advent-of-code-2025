points = File.readlines(ARGV[0]).map { |l| l.strip.split(",").map(&:to_i) }

puts points.inspect

xes = points.map { |p| p[0] }
yes = points.map { |p| p[1] }
bounds = [
  ((xes.min)..(xes.max)),
  ((yes.min)..(yes.max))
]

puts "Bounds: #{bounds}"

puts "Building green set..."
greens = Set.new
(points + [points[0]]).each_cons(2) do |a, b|
  if a[0] == b[0]
    # Vertical
    min_y = [a[1], b[1]].min
    max_y = [a[1], b[1]].max
    greens += (min_y..max_y).to_a.map { |y| [a[0], y] }
  else
    # Horizontal
    min_x = [a[0], b[0]].min
    max_x = [a[0], b[0]].max
    greens += (min_x..max_x).to_a.map { |x| [x, a[1]] }
  end
end

# puts "Building grid array..."
# grid = {}
# bounds[1].each do |y|
#   puts " - Row #{y} of #{bounds[1].size}"
#   grid[y] = {}
#   bounds[0].each do |x|
#     grid[y][x] = if greens.include? [x, y]
#       "X"
#     else
#       "."
#     end
#   end
# end

def draw_grid(grid)
  grid.each { |y, l|
    l.each { |x, c| print(c) }
    puts
  }
end

# Flood fill
def neighbours(x, y)
  [
    [x - 1, y],
    [x, y - 1],
    [x + 1, y],
    [x, y + 1]
  ]
end

puts "Prepping flood fill..."
start_point = [bounds[0].begin + bounds[0].size / 2, bounds[1].begin + bounds[1].size / 2]
complete_set = Set.new(greens)
set_to_evaluate = Set.new([start_point])

# draw_grid(grid)
puts
puts "FLOOD FILL"
i = 0
until set_to_evaluate.empty?
  puts "Iteration #{i + 1}"
  # draw_grid(grid)

  px, py = point = set_to_evaluate.first
  set_to_evaluate.delete(point)

  # grid[py][px] = "X"
  complete_set << point

  neighbours(px, py).each { |nx, ny|
    unless complete_set.include?([nx, ny])
      # if grid[ny][nx] == "."
      set_to_evaluate << [nx, ny]
    end
  }
end

puts "complete_set #{complete_set}"

# draw_grid(grid)

# invalid_set = Set.new

# grid.each { |y, l|
#   l.each { |x, c|
#     unless complete_set.include?([x, y])
#       invalid_set << [x, y]
#     end
#   }
# }

# puts "INVALID SET"
# puts invalid_set.inspect
# return

all_rectangles =
  points.combination(2).map { |(ax, ay), (bx, by)|
    x = [ax, bx].min
    y = [ay, by].min
    w = (ax - bx).abs + 1
    h = (ay - by).abs + 1
    a = (w * h).abs
    if ax == 9 && ay == 5
      puts "TEST: #{[ax, ay, bx, by]} -> #{[x, y, w, h, a]}"
    end
    [x, y, w, h, a]
  }
puts "All rectangles:"
all_rectangles.each do |rect|
  puts rect.inspect
end
puts

valid_rectangles = []
all_rectangles.each do |x, y, w, h, a|
  puts "Testing rectangle [#{x}, #{y}] -> [#{x + w}, #{y + h}] (#{a})"
  # invalid = invalid_set.any? { |ix, iy|
  #   puts "Does invalid point (#{ix}, #{iy}) appear?"
  #   if ix.between?(x, x + w - 1) && iy.between?(y, y + h - 1)
  #     puts "Yes! (#{[ix, iy]}) appears between x = (#{[x, x + w - 1]}) and y = #{[y, y + h - 1]}"
  #     true
  #   else
  #     false
  #   end
  # }
  # valid_rectangles << [x, y, w, h, a] unless invalid
  valid = complete_set.all? { |vx, vy|
    vx.between?(x, x + w - 1) && vy.between?(y, y + h - 1)
  }
  valid_rectangles << [x, y, w, h, a] if valid
end

puts "VALID RECTS"
puts valid_rectangles.inspect

max_rectangles = valid_rectangles.sort_by { |a| a[4] }[-5..].reverse
puts max_rectangles.inspect
puts max_rectangles[0].inspect
puts max_rectangles[0][4]

# invalid_points = []
# bounds[1].each do |y|
#   bounds[0].each do |x|
#     valid = false
#     puts "Testing if point #{x}, #{y} is valid"
#     all_rectangles.each do |rx, ry, w, h, _|
#       if x.between?(rx, rx + w) && y.between?(ry, ry + h)
#         puts "Valid, because within rect #{rx}, #{ry}, #{w}, #{h}"
#         valid = true
#         break
#       end
#     end
#     invalid_points << [x, y] unless valid
#   end
# end

# puts "Invalid points: #{invalid_points}"

# bounds[1].each do |y|
#   bounds[0].each do |x|
#     if invalid_points.include? [x, y]
#       print "."
#     elsif points.include? [x, y]
#       print "#"
#     else
#       print "X"
#     end
#   end
#   puts
# end

# max_area = input.combination(2).map { |a, b|
#   x = (a[0] - b[0]).abs + 1
#   y = (a[1] - b[1]).abs + 1
#   (x * y).abs
# }.max

# puts max_area
