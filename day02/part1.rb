input = File.readlines(ARGV[0])[0].scan(/(\d+)-(\d+)/)
puts input.inspect

# input.map { |(a, b)|
#   puts "#{b.length - a.length} - #{[a.length, b.length].inspect}"
# }

result = input.sum { |(a, b)|
  puts "\nTesting range #{a}-#{b}"

  if a.length.even?
    oom = a.length
    min_test = a[0..((a.length - 1) / 2)]
    max_test = [
      ("9" * (oom / 2)),
      b[0..((b.length - 1) / 2)]
    ].map(&:to_i).min.to_s
  elsif b.length.even?
    oom = b.length
    min_test = [
      "1".ljust(oom / 2, "0"),
      b[0..(oom / 2 - 1)]
    ].map(&:to_i).min.to_s
    max_test = b[0..(oom / 2 - 1)]
  else
    puts " - Odd lengths, no candidates"
    next 0
  end

  candidates = (min_test.to_i..max_test.to_i).map { |half| "#{half}#{half}".to_i }
  results = candidates.select { |c| c.between? a.to_i, b.to_i }

  if results.length == 0
    puts " - No candidates in range (#{candidates[0]}..#{candidates[-1]})"
    next 0
  end
  result_sum = results.sum

  puts " - (#{results[0]}..#{results[-1]})"
  next result_sum
}

puts "Result: #{result}"
