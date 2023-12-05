# frozen_string_literal: true

# data = File.open('example').read
data = File.open('input').read
seeds = data.split("\n\n")[0].split(': ')[1].split.map(&:to_i)

################################################################################
# Part 1
################################################################################

almanac = data.split("\n\n")[1..]
              .map { |chart| chart.split("\n")[1..].map { |l| l.split.map(&:to_i) } }

locations = []

def next_value(value, chart)
  chart.each do |(dst, src, len)|
    return dst + value - src if value.between? src, src + len - 1
  end

  value
end

def convert(value, maps)
  maps.each do |map|
    value = next_value(value, map)
  end

  value
end

seeds.each do |seed|
  seed = convert(seed, almanac)
  locations << seed
end

puts locations.min

################################################################################
# Part 2
# Smart solution: Intervals
################################################################################

seed_ranges = seeds.each_slice(2)
                   .to_a
                   .map { |(s, len)| [s, s + len] }

almanac.each do |map|
  new_ranges = []
  while seed_ranges.any?
    st, ed = seed_ranges.pop

    overlaps = false
    map.each do |(dst, src, len)|
      os = [st, src].max
      oe = [ed, src + len].min
      next unless os < oe

      overlaps = true
      new_ranges << [os - src + dst, oe - src + dst]
      seed_ranges << [st, os] if os > st
      seed_ranges << [oe, ed] if ed > oe
      break
    end
    new_ranges << [st, ed] unless overlaps
  end
  seed_ranges = new_ranges
end

pp seed_ranges.min.first

################################################################################
# Dumb solution: Brute force backwards
# 3.5min
################################################################################

seed_ranges = seeds.each_slice(2)
                   .to_a
                   .map { |(s, len)| [s, s + len] }

def reverse(value, reversed)
  reversed.each do |map|
    map.each do |(dst, src, len)|
      if value.between?(dst, dst + len - 1)
        value = value - dst + src
        break
      end
    end
  end

  value
end

location = 0

loop do
  value = reverse(location, almanac.reverse)
  seed_ranges.each do |(st, ed)|
    if value.between? st, ed - 1
      puts location
      exit
    end
  end

  location += 1
end
