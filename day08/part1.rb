junction_boxes = File.readlines(ARGV[0]).map { |line| line.strip.split(",").map(&:to_i) }

puts junction_boxes.inspect

CONNECTION_COUNT = 1000

distances = junction_boxes.combination(2).map { |a, b|
  [
    Math.sqrt(
      (a[0] - b[0])**2 +
      (a[1] - b[1])**2 +
      (a[2] - b[2])**2
    ),
    a, b
  ]
}

sorted_distances = distances.sort_by { |a| a[0] }
# puts "Shortest #{CONNECTION_COUNT} distances"
# sorted_distances[0..(CONNECTION_COUNT - 1)].each do |d|
#   puts d.inspect
# end

circuits = []
# i = 0
sorted_distances[0..(CONNECTION_COUNT - 1)].each do |dist, a, b|
  # puts "Adding #{a} - #{b} to circuit"
  existing_circuits = []
  circuits.each do |circuit|
    # puts "Testing if circuit #{circuit} includes #{a} or #{b}"
    if circuit.include?(a) || circuit.include?(b)
      # puts "It does!"
      existing_circuits += circuit
    end
  end
  # puts "Removing existing circuits #{existing_circuits} from #{circuits}"
  circuits.delete_if { |circuit| circuit.any? { |c| existing_circuits.include?(c) } }
  new_circuit = [a, b, *existing_circuits].uniq
  circuits << new_circuit
  # puts "Circuits:"
  # circuits.each { |c| puts c.inspect }
  # puts
end

result = circuits.map(&:length).sort[-3..].reduce(:*)
puts result
