# frozen_string_literal: true

data = File.open('input').read.split("\n").map(&:chars)

def distance((ar, ac), (br, bc))
  (ar - br).abs + (ac - bc).abs
end

def expand(data, factor)
  data.flat_map { |row| row.all?('.') ? [row] * factor : [row] }
      .transpose
      .flat_map { |col| col.all?('.') ? [col] * factor : [col] }
      .transpose
end

def galaxies(map)
  cols = map.first.length

  flat = map.flatten
  flat.each_index
      .select { |i| flat[i] == '#' }
      .map { |i| i.divmod(cols) }
end

def sum_of_distances(galaxies)
  galaxies.each_with_index.reduce(0) do |steps, (galaxy, i)|
    steps + galaxies[i + 1..].reduce(0) { |g_steps, other| g_steps + distance(galaxy, other) }
  end
end

part_one = sum_of_distances(galaxies(expand(data, 2)))
p part_one

base = sum_of_distances(galaxies(expand(data, 1)))
increase = part_one - base
p base + (increase * (1_000_000 - 1))
