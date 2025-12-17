input = File.readlines(ARGV[0]).map { |l| l.delete(":").split(" ") }
node_map = {}
input.each do |tokens|
  src = tokens[0]
  dsts = tokens[1..]
  node_map[src] = dsts
end

puts node_map.inspect

incomplete_paths = Set.new
complete_paths = Set.new

start = "you"
incomplete_paths += [[start]]
i = 0
until incomplete_paths.empty?
  i += 1
  puts "\nIteration #{i}"
  path = incomplete_paths.take(1)[0]
  incomplete_paths.delete(path)

  puts "Traversing path #{path}"

  current = path[-1]
  next_steps = node_map[current]
  next_steps.each { |next_step|
    new_path = path + [next_step]

    if next_step == "out"
      complete_paths << new_path
    else
      incomplete_paths << new_path
    end
  }
end

result = complete_paths.size
puts result
