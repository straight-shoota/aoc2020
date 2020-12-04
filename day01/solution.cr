expenses = ARGF.each_line.map(&.to_i).to_a

expenses.each_combination(2, reuse: true) do |p|
  puts p, p.product if p.sum == 2020
end

expenses.each_combination(3, reuse: true) do |p|
  puts p, p.product if p.sum == 2020
end
