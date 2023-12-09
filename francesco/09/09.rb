# frozen_string_literal: true

data = File.open('input')
           .read
           .split("\n")
           .map { |l| l.split.map(&:to_i) }

def next_value(hst)
  differences = hst.each_cons(2)
                   .map { |(m, n)| n - m }
  hst.last + (differences.uniq.length == 1 ? differences.first : next_value(differences))
end

next_values = data.map { next_value(_1) }
prev_values = data.map { next_value(_1.reverse) }

# data.each do |hst|
#   next_values << next_value(hst)
#   prev_values << next_value(hst.reverse)
# end

p next_values.sum
p prev_values.sum
