# frozen_string_literal: true
# rubocop:disable Metrics

require 'set'

DATA = File.open('input').read.split("\n").map(&:chars)

def bfs(graph, root)
  explored = Set.new([root])
  queue = [[root, 0]]
  max_steps = 0

  while queue.any?
    current, steps = queue.shift
    max_steps = steps

    graph[current].each do |neighbor|
      next if explored.include?(neighbor)

      explored.add(neighbor)
      queue << [neighbor, steps + 1]
    end
  end

  [explored, max_steps]
end

def connected?(dir, nxt)
  case dir
  when [0, -1] then ['|', 'F', '7'].include?(nxt)
  when [0, 1] then ['|', 'J', 'L'].include?(nxt)
  when [1, 0] then ['-', '7', 'J'].include?(nxt)
  when [-1, 0] then ['-', 'L', 'F'].include?(nxt)
  end
end

def in_bounds?((r, c), (dx, dy))
  (r + dy).between?(0, DATA.length - 1) &&
    (c + dx).between?(0, DATA.first.length - 1)
end

def neighbor_rc((r, c), (dx, dy))
  [r + dy, c + dx]
end

def get_neighbor((r, c), (dx, dy))
  DATA[r + dy][c + dx]
end

def directions(pipe)
  dirs = {
    'S' => [[0, 1], [0, -1], [1, 0], [-1, 0]],
    '|' => [[0, 1], [0, -1]],
    'F' => [[1, 0], [0, 1]],
    '-' => [[1, 0], [-1, 0]],
    '7' => [[0, 1], [-1, 0]],
    'J' => [[-1, 0], [0, -1]],
    'L' => [[0, -1], [1, 0]]
  }
  dirs[pipe]
end

def neighbors(r, c)
  pipe = DATA[r][c]

  directions(pipe).each_with_object([]) do |dir, dirs|
    curr = [r, c]
    next unless in_bounds?(curr, dir)

    nxt = get_neighbor(curr, dir)
    dirs << neighbor_rc(curr, dir) if connected?(dir, nxt)
  end
end

def build_graph
  node_graph = {}

  DATA.each_with_index do |row, r|
    row.each_with_index do |_, c|
      node_graph[[r, c]] = neighbors(r, c) unless DATA[r][c] == '.'
    end
  end

  node_graph
end

graph = build_graph
root = DATA.flatten.index('S').divmod(DATA.first.length)

loop, steps = bfs(graph, root)
p steps

count = 0
DATA.each_with_index do |row, r|
  inside = false
  edge_start = ''
  row.each_with_index do |char, c|
    if loop.include? [r, c]
      case char
      when '|'
        inside = !inside
      when 'L', 'F'
        edge_start = char
      when '7'
        inside = !inside if edge_start == 'L'
        edge_start = ''
      when 'J'
        inside = !inside if edge_start == 'F'
        edge_start = ''
      end
    elsif inside == true
      count += 1
    end
  end
end

p count
