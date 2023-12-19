# frozen_string_literal: true
# rubocop:disable Metrics

require 'set'

INPUT = File.open('input').read.split("\n").map(&:chars)
ROWS = INPUT.length
COLS = INPUT.first.length
DIRS = { u: [-1, 0], d: [1, 0], l: [0, -1], r: [0, 1] }.freeze

REFLECT = {
  DIRS[:u] => { '/' => DIRS[:r], '\\' => DIRS[:l] },
  DIRS[:d] => { '/' => DIRS[:l], '\\' => DIRS[:r] },
  DIRS[:l] => { '/' => DIRS[:d], '\\' => DIRS[:u] },
  DIRS[:r] => { '/' => DIRS[:u], '\\' => DIRS[:d] }
}.freeze

REFRACT = {
  '|' => [DIRS[:u], DIRS[:d]],
  '-' => [DIRS[:l], DIRS[:r]]
}.freeze

def bfs(src, dir)
  first = [src, dir]
  visited = Set.new
  queue = [first]

  while queue.any?
    (r, c), (dr, dc) = queue.shift
    r += dr
    c += dc

    next unless r.between?(0, ROWS - 1) && c.between?(0, COLS - 1)

    char = INPUT[r][c]
    if (char == '.' || (char == '-' && dr.zero?) || (char == '|' && dc.zero?)) && !visited.include?([[r, c], [dr, dc]])
      visited << [[r, c], [dr, dc]]
      queue << [[r, c], [dr, dc]]
    elsif REFLECT[[dr, dc]][char] && !visited.include?([[r, c], REFLECT[[dr, dc]][char]])
      visited << [[r, c], REFLECT[[dr, dc]][char]]
      queue << [[r, c], REFLECT[[dr, dc]][char]]
    else
      REFRACT[char].each do |(drn, dcn)|
        unless visited.include?([[r, c], [drn, dcn]])
          visited << [[r, c], [drn, dcn]]
          queue << [[r, c], [drn, dcn]]
        end
      end
    end
  end

  energized = Set.new
  energized.merge(visited.to_a.map { |((row, col), (_dr, _dc))| [row, col] })
  energized.length
end

part_one = bfs([0, -1], DIRS[:r])
puts part_one

max = 0

ROWS.times do |r|
  right = bfs([r, -1], DIRS[:r])
  left = bfs([r, ROWS], DIRS[:l])
  max = [max, right, left].max
end

COLS.times do |c|
  down = bfs([-1, c], DIRS[:d])
  up = bfs([COLS, c], DIRS[:u])
  max = [max, down, up].max
end

p max
