require "bit_array"

record Instruction,
  operation : String,
  argument : Int32

instructions = [] of Instruction
ARGF.each_line do |line|
  operation = line.byte_slice(0, 3)
  argument = line.byte_slice(4).to_i
  instructions << Instruction.new(operation, argument)
end

def run(instructions, tracker = BitArray.new(instructions.size), fail_on_loop = true)
  acc = 0
  instruction_pointer = 0
  while true
    instruction = instructions[instruction_pointer]?
    break unless instruction
    if tracker[instruction_pointer]
      if fail_on_loop
        raise "loop"
      else
        break
      end
    else
      tracker[instruction_pointer] = true
    end
    case instruction.operation
    when "acc"
      acc += instruction.argument
      instruction_pointer += 1
    when "jmp"
      instruction_pointer += instruction.argument
    when "nop"
      instruction_pointer += 1
    end
  end
  acc
end

p! run(instructions, fail_on_loop: false)

def backtrack(instructions, target, reachable)
  found = [] of {Int32, Instruction}
  instructions.each_with_index do |instruction, i|
    if (instruction.operation == "jmp" && (i + 1 == target)) ||
       (instruction.operation == "nop" && (i + instruction.argument == target))

      print "#{i}. #{instruction}: "
      if reachable[i]
        puts "reachable"
        instructions[i] = Instruction.new(instruction.operation == "jmp" ? "nop" : "jmp", instruction.argument)
        return true
      else
        puts "backtrack"
        if backtrack(instructions, i, reachable)
          return true
        end
      end
    end
  end
  raise "not found: #{target}"
end

reachable = BitArray.new(instructions.size)
run(instructions, reachable, fail_on_loop: false)

#backtrack(instructions, instructions.size, reachable)
  #p! run(instructions)

instructions.each_with_index do |instruction, i|
  if instruction.operation.in?("jmp", "nop")
    dup_instructions = instructions.dup
    dup_instructions[i] = Instruction.new(instruction.operation == "jmp" ? "nop" : "jmp", instruction.argument)
    result = run(dup_instructions, fail_on_loop: true) rescue nil 

    if result
      p! i, result
    end
  end
end
