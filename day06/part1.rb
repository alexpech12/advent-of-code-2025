input = File.readlines(ARGV[0]).map { |line| line.scan(/([0-9*+]+)/).flatten.map(&:strip) }

puts input.inspect
puts input.transpose.inspect

result = input.transpose.sum { |command|
  if command[-1] == "*"
    command[0..-2].map(&:to_i).reduce(:*)
  else
    command[0..-2].map(&:to_i).sum
  end
}
puts result
