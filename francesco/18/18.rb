# frozen_string_literal: true

require 'set'

input = File.open('input').read
instructions = input.split("\n")
                    .map(&:split)
                    .map { |(dir, length, hex)| [dir, length.to_i, hex] }

def move(x, y, dir, length)
  case dir
  when 'U' then y += length
  when 'D' then y -= length
  when 'L' then x -= length
  when 'R' then x += length
  end
  [x, y]
end

def direction_groups(instructions)
  (instructions.map(&:first).flatten.join * 3)
    .slice(instructions.length - 1, instructions.length + 3)
    .chars.each_cons(3).map(&:join)
end

def dig_trench(instructions, directions, x = 0, y = 0)
  instructions.zip(directions)
              .each_with_object([]) do |((dir, length, _hex), group), arr|
    case group
    when /URD|DLU|RDL|LUR/ then length += 1
    when /ULD|DRU|LDR|RUL/ then length -= 1
    end
    x, y = move(x, y, dir, length)
    arr << [x, y]
  end
end

def find_area(trench)
  # Shoelace formula
  # # A = 0.5 * |(x1*y2 - x2*y1) + (x2*y3 - x3*y2) + ... + (xn*y1 - x1*yn)|
  trench.each_cons(2).reduce(0) { |sum, ((x1, y1), (x2, y2))| sum + (x1 * y2 - x2 * y1) }.abs / 2
end

directions = direction_groups(instructions)
p find_area(dig_trench(instructions, directions))

key = { '0' => 'R', '1' => 'D', '2' => 'L', '3' => 'U' }

new_instructions = instructions.map { |l| l[2].match(/\(#(.*)\)/)[1] }
                               .map { |code| [key[code[-1]], code[...-1].to_i(16)] }
new_directions = direction_groups(new_instructions)
p find_area(dig_trench(new_instructions, new_directions))
