raw_fresh_ranges, raw_ids =
  File.readlines(ARGV[0])
    .join("")
    .split("\n\n")
    .map { |section| section.split("\n") }

puts raw_fresh_ranges.inspect
puts
puts raw_ids.inspect

fresh_ranges = raw_fresh_ranges
  .map { |line| line.split("-").map(&:to_i) }
  .map { |(a, b)| (a..b) }
puts fresh_ranges.inspect

ids = raw_ids.map(&:to_i)

result = ids.count { |id| fresh_ranges.any? { |range| range === id } }

puts result
