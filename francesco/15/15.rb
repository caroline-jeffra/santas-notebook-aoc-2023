# frozen_string_literal: true

input = File.open('input').read.chomp.split(',')

def hash_algorithm(seq)
  seq.chars.reduce(0) { |sum, c| (sum + c.ord) * 17 % 256 }
end

part_one = input.reduce(0) { |hash, step| hash + hash_algorithm(step) }

p part_one

hash = {}

input.each do |seq|
  if seq =~ /=/
    label, length = seq.split('=')
    hash[hash_algorithm(label)] = {} unless hash.key? hash_algorithm(label)

    hash[hash_algorithm(label)].store(label, length)
  elsif seq =~ /-/
    label = seq.chomp('-')
    hash[hash_algorithm(label)]&.delete(label)
  end
end

part_two = hash.each_pair.reduce(0) do |total, (k, v)|
  total + (k + 1) * v.values.each_with_index.reduce(0) do |sum, (length, i)|
    sum + (i + 1) * length.to_i
  end
end

p part_two
