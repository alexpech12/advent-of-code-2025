input = File.readlines(ARGV[0]).map { |line| line.strip.chars.map(&:to_i) }
puts input.inspect

result = input.sum do |b|
  puts b.inspect
  ai = b.index(b[0..-2].max)
  bi = b.index(b[(ai + 1)..].max)
  puts "#{b[ai]}#{b[bi]}".to_i
  "#{b[ai]}#{b[bi]}".to_i
end
puts result
