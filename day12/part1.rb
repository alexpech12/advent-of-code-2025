input_sections = File.readlines(ARGV[0]).join("").split("\n\n")

raw_shapes = input_sections[0..-2]
raw_areas = input_sections[-1]

shapes = raw_shapes.map { |str| str.split("\n")[1..] }
areas = raw_areas.split("\n").map { |line| line.scan(/(\d+)/).flatten.map(&:to_i) }

puts shapes.inspect
puts areas.inspect

shape_sizes = shapes.map { |shape| shape.sum { |s| s.count("#") } }
puts shape_sizes.inspect

# Initial check - is it even possible for the given shape sizes to fit into the area?
cnt = 0
areas.each do |area_def|
  w, h, *amts = area_def

  area = w * h
  shape_area = amts.map.with_index { |amt, i|
    amt * shape_sizes[i]
  }.sum
  puts "can area #{area} fit shapes #{amts} = #{shape_area}?"
  if shape_area > area
    puts "NO!"
  else
    puts "... yes"
    cnt += 1
  end
end
puts cnt
