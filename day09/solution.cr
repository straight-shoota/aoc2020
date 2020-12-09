numbers = ARGF.each_line.map(&.to_i64).to_a

window_size = ENV["WINDOW_SIZE"]? || 25

struct Window
  def initialize(@numbers : Array(Int64), @window_size : Int32, @pointer : Int32 = window_size)
  end

  def [](index : Int32)
    @numbers[index]
  end

  def value
    self[@pointer]
  end

  def valid?
    value = self.value
    @window_size.times do |x|
      (@window_size - x).times do |y|
        sum = self[@pointer - x - 1] + self[@pointer - y - 1 - x]
        return true if sum == value
      end
    end

    false
  end

  def next
    if @pointer < @numbers.size - 1
      self.class.new(@numbers, @window_size, @pointer + 1)
    end
  end
end

window = Window.new(numbers, window_size.to_i).next

while window && window.valid?
  window = window.next
end

unless window
  abort "no invalid number found"
end

puts "part1: #{window.value}"

invalid_value = window.value
(window.@pointer - 1).downto(0) do |start_index|
  index = start_index + 1
  sum = 0
  while sum < invalid_value
    index -= 1
    sum += numbers[index]
  end
  if sum == invalid_value
    encryption_weakness = numbers[index..start_index].minmax.sum

    puts "part2: #{encryption_weakness}"
    exit
  end
end

