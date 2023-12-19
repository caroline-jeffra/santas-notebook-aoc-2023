# frozen_string_literal: true
# rubocop:disable Metrics

require 'set'

INPUT = File.open('input').read.split("\n").map(&:chars)
ROWS = INPUT.length
COLS = INPUT.first.length
DIRS = { u: [-1, 0], d: [1, 0], l: [0, -1], r: [0, 1] }.freeze
EXPLORED = Set.new

REFLECT = {
  DIRS[:u] => { '/' => DIRS[:r], '\\' => DIRS[:l], '|' => DIRS[:u] },
  DIRS[:d] => { '/' => DIRS[:l], '\\' => DIRS[:r], '|' => DIRS[:d] },
  DIRS[:l] => { '/' => DIRS[:d], '\\' => DIRS[:u], '-' => DIRS[:l] },
  DIRS[:r] => { '/' => DIRS[:u], '\\' => DIRS[:d], '-' => DIRS[:r] }
}.freeze

REFRACT = {
  '|' => [DIRS[:u], DIRS[:d]],
  '-' => [DIRS[:l], DIRS[:r]]
}.freeze

def beam(pos, dir)
  r, c = pos
  dr, dc = dir
  loop do
    r += dr
    c += dc
    return unless r.between?(0, ROWS - 1) && c.between?(0, COLS - 1)
    return if EXPLORED.include?([[r, c], dir])

    EXPLORED << [[r, c], dir]
    char = INPUT[r][c]
    break if char != '.'
  end
  char = INPUT[r][c]
  new_dir = REFLECT[dir][char]
  if new_dir
    beam([r, c], new_dir)
  else
    REFRACT[char].each do |split_dir|
      beam([r, c], split_dir)
    end
  end
end

def energized
  count = Set.new.merge(EXPLORED.to_a.map { |(pos, _dir)| pos }).size
  EXPLORED.clear
  count
end

beam([0, -1], DIRS[:r])
p energized

max = 0
ROWS.times do |r|
  beam([r, -1], DIRS[:r])
  right = energized
  beam([r, COLS], DIRS[:l])
  left = energized
  max = [max, right, left].max
end

COLS.times do |c|
  beam([-1, c], DIRS[:d])
  down = energized
  beam([ROWS, c], DIRS[:u])
  up = energized
  max = [max, down, up].max
end

puts max
