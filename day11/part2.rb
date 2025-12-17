input = File.readlines(ARGV[0]).map { |l| l.delete(":").split(" ") }
node_map = {}
input.each do |tokens|
  src = tokens[0]
  dsts = tokens[1..]
  node_map[src] = dsts
end

puts node_map.inspect

def count_paths(node_map, src, dst, count_cache = {})
  cache_key = "#{src}-#{dst}"
  cached_count = count_cache[cache_key]
  if cached_count.nil?
    # Is dst a direct connection to src?
    # If so, there is one path
    # Else, the answer is the sum of all the paths from src's dsts to dst
    dsts = node_map[src]
    count =
      if dsts.nil? # Dead-end
        0
      elsif dsts.include?(dst) # One step away
        1
      else # Recurse
        dsts.sum { |nsrc| count_paths(node_map, nsrc, dst, count_cache) }
      end
    puts "Cached value #{cache_key} = #{count}"
    count_cache[cache_key] = count
  else
    puts "Cache hit!"
    cached_count
  end
end

result_to_fft = count_paths(node_map, "svr", "fft")
result_to_dac = count_paths(node_map, "fft", "dac")
result_to_out = count_paths(node_map, "dac", "out")
puts "results: #{result_to_fft}, #{result_to_dac}, #{result_to_out}"
result = [result_to_fft, result_to_dac, result_to_out].reduce(:*)
puts "final result: #{result}"
