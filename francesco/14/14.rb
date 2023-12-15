# frozen_string_literal: true

require 'set'

input = File.open('input').read.split("\n").map(&:chars)
COLS = input.first.length
ROWS = input.length
NWSE = [[-1, 0], [0, -1], [1, 0], [0, 1]]

# Stores coordinates of rocks into two sets
SQUARES, CIRCLES = input.flatten
                        .each_with_index
                        .each_with_object([Set.new, Set.new]) do |(c, i), (sr, rr)|
  sr << i.divmod(COLS) if c == '#'
  rr << i.divmod(COLS) if c == 'O'
end

# Returns true if the rock's new position is illegal
def not_valid?(circle)
  SQUARES.include?(circle) ||
    CIRCLES.include?(circle) ||
    circle.any?(&:negative?) ||
    circle.first >= ROWS ||
    circle.last >= COLS
end

# Moves the rock in the desired direction until it meets an obstacle
def tilt(circle, (dr, dc))
  until not_valid?(circle)
    circle[0] += dr
    circle[1] += dc
  end
  circle[0] -= dr
  circle[1] -= dc
  circle
end

sequences = {}
repeating = []
1_000_000_000.times do |i|
  sequence = []
  NWSE.each do |dir|
    # Sorts the rocks:
    # Top -> Bottom, Left -> Right for N & W
    # Bottom -> Top, Right -> Left for S & E
    sign = dir.reject(&:zero?).first
    CIRCLES.to_a
           .sort { |(aa, ab), (ba, bb)| aa == ba ? sign * (bb - ab) : sign * (ba - aa) }
           .each do |circle|
      # Updates the rock's coordinates
      CIRCLES.delete(circle)
      CIRCLES << tilt(circle, dir)
    end
    # Calculates the total load, stores it into the sequence array
    sequence << CIRCLES.to_a.reduce(0) { |load, (r, _c)| load + ROWS - r }
  end
  # Prints the answer to Part 1
  puts sequence.first if i.zero?
  # If the sequence has appeared before, the arrangements have begun looping
  if sequences.key? sequence
    repeating = [sequence, i + 1]
    break
  end
  sequences[sequence] = i + 1
end

cycle_start = sequences[repeating.first]
period = repeating.last - cycle_start
puts sequences.invert[((1_000_000_000 - cycle_start) % period) + cycle_start].last
