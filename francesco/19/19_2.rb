require 'set'

workflows, _parts = File.open('input')
                        .read
                        .split("\n\n")
                        .map { |s| s.split("\n") }

WORKFLOWS = workflows.each_with_object({}) do |workflow, hash|
  name, rules = workflow.match(/(\w+){(.*)}/).captures
  rules = rules.gsub(':', ' ? ')
               .gsub(',', ' : ')
  hash[name] = rules
end

RANGES = Set.new

def set_gt_range(t_range, f_range, part, limit)
  t_range[part] = (limit + 1)..t_range[part].last if limit + 1 > t_range[part].first
  f_range[part] = f_range[part].first..limit if limit < f_range[part].last
end

def set_lt_range(t_range, f_range, part, limit)
  t_range[part] = t_range[part].first..(limit - 1) if limit - 1 < t_range[part].last
  f_range[part] = limit..f_range[part].last if limit > f_range[part].first
end

def update_ranges(t_range, f_range, condition)
  part, operator, limit = condition.match(/([xmas])([<>])(\d+)/).captures
  limit = limit.to_i
  if operator == '<'
    set_lt_range(t_range, f_range, part, limit)
  elsif operator == '>'
    set_gt_range(t_range, f_range, part, limit)
  end
end

def child_ranges(node, range)
  condition, rest = node.split(' ? ', 2)
  t, f = rest.split(' : ', 2)
  t_range = range.dup
  f_range = range.dup
  update_ranges(t_range, f_range, condition)
  [[t, t_range], [f, f_range]]
end

def store_accepted_ranges(node, range)
  t_f_pairs = child_ranges(node, range)
  t_f_pairs.each do |str, hash|
    case str
    when 'R' then false
    when 'A' then RANGES << hash.values
    when /\?/ then store_accepted_ranges(str, hash)
    when /^[a-z]{2,}$/ then store_accepted_ranges(WORKFLOWS[str], hash)
    end
  end
end

start_node = WORKFLOWS['in']
start_range = { 'x' => 1..4000, 'm' => 1..4000, 'a' => 1..4000, 's' => 1..4000 }
store_accepted_ranges(start_node, start_range)
p RANGES.map { |range| range.map(&:size).reduce(&:*) }.sum
