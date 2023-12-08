# frozen_string_literal: true

data = File.open('input')
           .read

path, node_list = data.split("\n\n")

nodes = node_list.split("\n")
                 .map { |l| l.scan(/\w+/) }
                 .reduce({}) { |hash, (k, l, r)| hash.update(k => { 'L' => l, 'R' => r }) }

def count_steps(path, nodes, src, target)
  steps = 0
  until src.end_with? target
    path.each_char do |d|
      src = nodes[src][d]
      steps += 1
    end
  end

  steps
end

################################################################################
# PART 1
################################################################################

part_one = count_steps(path, nodes, 'AAA', 'ZZZ')
p part_one

################################################################################
# PART 2
################################################################################

src_nodes = nodes.keys.filter { |k| k[-1] == 'A' }
part_two = src_nodes.map { |n| count_steps(path, nodes, n, 'Z') }.reduce(1, :lcm)
p part_two
