input = File.readlines(ARGV[0]).map { |line| line.scan(/([A-z])(\d+)/) }
acc = 50
result =
  input.count { |((d, v))|
    amt = (d == "L") ? -v.to_i : v.to_i
    acc = (acc + amt) % 100
    acc == 0
  }
puts "Result: #{result}"
