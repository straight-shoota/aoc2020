record Seat,
  row : Int32,
  column : Int32 do
    def id
      row * 8 + column
    end

    def inspect(io)
      io << "Seat(@row=" << row << ", @column=" << column << ", id=" << id << ")"
    end

    include Comparable(Seat)
    def <=>(other : Seat)
      id <=> other.id
    end
  end

seats = [] of Seat
ARGF.each_line do |line|
  row = line[0...7].each_char.reduce(0) { |memo, char| memo * 2 + (char == 'B' ? 1 : 0) }
  column = line[7...10].each_char.reduce(0) { |memo, char| memo * 2 + (char == 'R' ? 1 : 0) }
  seats << Seat.new row, column
end

p! seats.max

seats.sort.each_cons_pair do |a, b|
  if a.id < b.id - 1
    puts b.id - 1
  end
end
