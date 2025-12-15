input = File.readlines(ARGV[0]).map { |line| line.scan(/([A-z])(\d+)/) }
acc = 50
result = 0
input.each do |((d, v))|
  direction = (d == "R") ? 1 : -1
  v.to_i.times do
    acc += direction
    acc %= 100
    result += 1 if acc.zero?
  end
end
puts result
