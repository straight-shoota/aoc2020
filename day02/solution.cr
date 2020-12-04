record Entry, range : Range(Int32, Int32), char : String, password : String

records = ARGF.each_line.map do |line|
  policy, _, password = line.partition(": ")
  range, _, char = policy.partition(" ")
  start, _, end = range.partition("-")
  Entry.new((start.to_i)..(end.to_i), char, password)
end.to_a

puts "part1: #{records.count { |r| r.range.includes?(r.password.count(r.char)) }}"
puts "part2: #{records.count { |r| (r.password[r.range.begin - 1]? == r.char[0]) ^ (r.password[r.range.end - 1]? == r.char[0]) }}"
