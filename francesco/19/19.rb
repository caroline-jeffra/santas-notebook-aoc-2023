# frozen_string_literal: true

# rubocop:disable Metrics

require 'set'

workflows, parts = File.open('input')
                       .read
                       .split("\n\n")
                       .map { |s| s.split("\n") }

ACCEPTED = []
WORKFLOWS = {}

def A(part)
  ACCEPTED << part
end

def R(part); end

workflows.map! do |workflow|
  name, rules = workflow.match(/(\w+){(.*)}/).captures
  rules = rules.gsub(':', ' ? ')
               .gsub(',', ' : ')
  WORKFLOWS[name] = rules
  rules = rules.gsub(/([a-z]{2,})/, '\1(args)')
               .gsub(/(A|R)/, '\1(args)')

  define_method(name.to_sym) do |args|
    x, m, a, s = args
    eval rules
  end
end
parts.map! { |part| part.scan(/\d+/).map(&:to_i) }
parts.each { |part| send(:in, part) }

p ACCEPTED.map(&:sum).sum

RANGES = Set.new

def update_ranges(t_range, f_range, condition)
  part, operator, limit = condition.match(/([xmas])([<>])(\d+)/).captures
  limit = limit.to_i
  if operator == '<'
    t_range[part] = t_range[part].first..(limit - 1) if limit - 1 < t_range[part].last
    f_range[part] = limit..f_range[part].last if limit > f_range[part].first
  elsif operator == '>'
    t_range[part] = (limit + 1)..t_range[part].last if limit + 1 > t_range[part].first
    f_range[part] = f_range[part].first..limit if limit < f_range[part].last
  end
end

def accepted_ranges(node, range)
  condition, rest = node.split(' ? ', 2)
  t, f = rest.split(' : ', 2)
  t_range = range.dup
  f_range = range.dup
  update_ranges(t_range, f_range, condition)
  [[t, t_range], [f, f_range]].each do |str, hash|
    case str
    when 'R' then false
    when 'A'
      RANGES << hash.values
    when /\?/ then accepted_ranges(str, hash)
    when /^[a-z]{2,}$/ then accepted_ranges(WORKFLOWS[str], hash)
    end
  end
end

start_node = WORKFLOWS['in']
start_range = { 'x' => 1..4000, 'm' => 1..4000, 'a' => 1..4000, 's' => 1..4000 }
accepted_ranges(start_node, start_range)
p RANGES.map { |range| range.map(&:size).reduce(&:*) }.sum
