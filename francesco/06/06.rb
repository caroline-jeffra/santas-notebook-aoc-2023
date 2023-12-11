# frozen_string_literal: true

data = File.open('input').read.split("\n")

# distance (d), duration (t), elapsed time (x)
#    d = x * (t - x)
# => x^2 -tx + d = 0
# => x = (t ± √t^2 - 4d)/2

def largest_int_lt(float)
  float == float.floor ? float.floor - 1 : float.floor
end

def num_possible_wins((time, record))
  dscr = Math.sqrt(time**2 - 4 * record)
  zeroes = [0.5 * (time + dscr), 0.5 * (time - dscr)]
  min_time = zeroes.min.floor + 1
  max_time = largest_int_lt(zeroes.max)

  max_time - min_time + 1
end

################################################################################
# Part 1
################################################################################

p1_data = data.map do |l|
  l.split(':')[1]
   .strip
   .gsub(/\s+/, ' ')
   .split
   .map(&:to_i)
end

p1_pairs = p1_data.transpose

part_one = p1_pairs.reduce(1) { |margin, pair| margin * num_possible_wins(pair) }
puts part_one

################################################################################
# Part 2
################################################################################

p2_pairs = data.map do |l|
  l.split(':')[1]
   .strip
   .gsub(/\s+/, '')
   .to_i
end

part_two = num_possible_wins(p2_pairs)
puts part_two
