MAP = [] of Array(Bool)

ARGF.each_line do |line|
  MAP << line.chars.map(&.==('#'))
end

record Point, x : Int32, y : Int32 do
  def move(x = 0, y = 0)
    self.class.new(@x + x, @y + y)
  end
end

pos = Point.new 0, 0

def traverse(pos, x, y)
  trees = 0
  while true
    pos = pos.move(x, y)
    break if pos.y + 1 > MAP.size
    row = MAP[pos.y]
    tree = row[pos.x % row.size]
    if tree
      trees += 1
    end
  end
  trees
end

p! traverse(pos, 3, 1)

traversals = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
p! traversals.map { |x, y| traverse(pos, x, y) }.product(1_i64)
