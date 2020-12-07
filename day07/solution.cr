record Rule,
  quantity : Int32,
  bag : String

RULES = {} of String => Array(Rule)
ARGF.each_line do |line|
  name, _, entries = line.partition(" bags contain ")
  entries = entries.rchop(".")
  subrules = [] of Rule
  if entries != "no other bags"
    entries.split(", ").each do |entry|
      quantity, _, entry_name = entry.partition(" ")
      subrules << Rule.new(quantity.to_i, entry_name.rchop?(" bags") || entry_name.rchop(" bag"))
    end
  end
  RULES[name] = subrules
end

# part1
set1 = Set{"shiny gold"}
checked_names = 0

while set1.size != checked_names
  checked_names = set1.size
  RULES.each do |bag, bag_rules|
    if bag_rules.any? { |r| r.bag.in?(set1) }
      set1 << bag
    end
  end
end

set1.delete "shiny gold"
p! set1.size

# part2
def count_bags(rules) : Int32
  rules.sum { |rule| rule.quantity * (count_bags(RULES[rule.bag]) + 1) }
end
p! count_bags(RULES["shiny gold"])


