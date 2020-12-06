require "bit_array"

count_or = 0
count_and = 0
found = Array(Int32).new(26, 0)
members_in_group = 0
last_was_nl = false

ARGF.each_char do |c|
  if c == '\n'
    if last_was_nl
      count_or += found.count(&.>(0))
      count_and += found.count(&.==(members_in_group)) 
      found.fill(0)
      members_in_group = 0
    else
      members_in_group += 1
      last_was_nl = true
      next 
    end
  else
    index = c - 'a'
    found[index] += 1
  end
  last_was_nl = false
end
p! count_or, count_and
