# frozen_string_literal: true

input = File.open('input').read

schematic = input.split("\n")
                 .map { |l| l.split.map.with_index { |p, i| i == 1 ? p.split(',').map(&:to_i) : p } }

def valid_segment?(str, groups)
  str[0] =~ /[#?]/ &&                                  # Character is or could be '#'
    str.length >= groups.first &&                      # Enough space for required number of '#'
    str[...groups.first] !~ /\./ &&                    # No '.' within the group's length. A '.' implies multiple groups
    (str.length == groups[0] || str[groups[0]] != '#') # If str length ≠ group length, ensure next character isn't '#'
end

def skip_dots_and_question_marks(str, groups, memo)
  return 0 unless str[0] =~ /[.?]/

  next_str = str[1..]
  memo[[next_str, groups]] = arrangements(next_str, groups, memo)
end

def count_arrangements(str, groups, memo)
  count = 0

  count += skip_dots_and_question_marks(str, groups, memo)

  return count unless valid_segment?(str, groups)

  next_segment = str[groups.first + 1..]
  remaining_groups = groups[1..]

  # Check the next segment recursively
  memo[[next_segment, remaining_groups]] = arrangements(next_segment, remaining_groups, memo)
  count + memo[[next_segment, remaining_groups]]
end

def arrangements(str, groups, memo = {})
  # Base cases
  return (groups.empty? ? 1 : 0) if str.nil? || str.empty? # String consumed, groups consumed / present
  return (str.include?('#') ? 0 : 1) if groups.empty?      # Groups consumed, '#' still left in str
  return memo[[str, groups]] if memo.key?([str, groups])   # Use values in memo to avoid having to compute again

  count = count_arrangements(str, groups, memo)
  memo[[str, groups]] = count
end

def solve(schematic, folds)
  unfolded = schematic.map { |(str, groups)| [([str] * folds).join('?'), groups * folds] }
  unfolded.reduce(0) { |total, (str, groups)| total + arrangements(str, groups) }
end

p solve(schematic, 1)
p solve(schematic, 5)
