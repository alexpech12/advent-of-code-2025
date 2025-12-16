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

def reduce_ranges(ranges)
  ranges.sort_by(&:begin).each_with_object([]) { |range, acc|
    # Does range fit into an existing range?
    # If so, combine
    # Otherwise, add as new range
    existing_range_index = acc.index { |existing|
      range.overlap?(existing)
    }
    if existing_range_index.nil?
      acc << range
    else
      existing = acc[existing_range_index]
      combined_range = (([existing.begin, range.begin].min)..([existing.end, range.end].max))
      acc[existing_range_index] = combined_range
    end
  }
end

reduced = reduce_ranges(fresh_ranges)
puts reduced.inspect

result = reduced.sum(&:count)
puts result

# def combine_ranges(r1, r2)
#   if r1.begin < r2.begin
#     a = r1
#     b = r2
#   else
#     a = r2
#     b = r1
#   end

#   a1, a2, b1, b2 = [a.begin, a.end, b.begin, b.end]

#   if a2 < b1
#     # No overlap
#     [(a1..a2), (b1..b2)]
#   elsif b2 > a2
#     # Join ranges
#     [(a1..b2)]
#   else
#     # A covers B
#     [a]
#   end
# end

# combined = fresh_ranges.reduce([fresh_ranges[0]]) { |acc, range|
#   acc << combine_ranges(fresh_ranges[-1], range)
# }
