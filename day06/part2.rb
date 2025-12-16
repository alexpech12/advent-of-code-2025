input = File.readlines(ARGV[0]).map { |line| line.delete("\n") }

# Pad with spaces to make rows even
required_length = input.map(&:length).max
input = input.map { |line| line.ljust(required_length, " ") }
transposed = input.map(&:chars).transpose.map(&:join)

puts input.inspect
puts input.map(&:chars).inspect
puts input.map(&:chars).transpose.inspect
puts transposed.inspect

puts
transposed.each { |l| puts l.inspect }

sums = transposed.chunk_while { |line| line.strip != "" }.to_a
puts sums.inspect

result = sums.sum do |sum_data|
  operation =
    if sum_data[0].include? "*"
      ->(arr) { arr.reduce(:*) }
    else
      ->(arr) { arr.sum }
    end

  operands = sum_data.reject { |x| x.strip == "" }.map(&:to_i)
  operation.call(operands)
end
puts result
