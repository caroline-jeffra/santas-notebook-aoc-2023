# frozen_string_literal: true

patterns = File.open('input').read.split("\n\n").map { _1.split("\n") }

def columns(pattern)
  pattern.map(&:chars)
         .transpose
         .map(&:join)
end

def smudge?(first, second)
  first.chars.zip(second.chars).count { |a, b| a != b } == 1
end

def reflection?(pattern, (left, right))
  smudge_count = 0
  pattern[..left].reverse.zip(pattern[right..])
                 .filter { _1.compact.length == 2 }
                 .each do |a, b|
                   next unless a != b
                   return false unless @part == 2 && smudge_count < 1 && smudge?(a, b)

                   smudge_count += 1
                 end
  @part == 2 ? smudge_count == 1 : true
end

def matches(pattern)
  pattern.each_with_index
         .each_cons(2)
         .with_object([]) { |((a, i), (b, j)), arr| arr << [i, j] if (smudge?(a, b) && @part == 2) || a == b }
end

def find_reflection(pattern)
  reflections = matches(pattern).filter { |lr| reflection?(pattern, lr) }
  reflections.first&.last
end

def reflection_summary(pattern)
  horizontal_reflection = find_reflection(pattern)
  return 100 * horizontal_reflection if horizontal_reflection

  find_reflection(columns(pattern))
end

@part = 1
puts patterns.reduce(0) { |sum, pattern| sum + reflection_summary(pattern) }
@part = 2
puts patterns.reduce(0) { |sum, pattern| sum + reflection_summary(pattern) }
