# frozen_string_literal: true

require 'prime'
require 'set'

def num_digits(num)
  num.to_s.length
end

def circular_permutations(num)
  str = num.to_s
  length = str.length
  permutations = []
  length.times do |i|
    permutations << (str * 2)[length - i, length].to_i
  end

  permutations
end

def permutation_limit_estimate(lim)
  base = 10**Math.log10(lim).to_i
  mod = lim % base
  quot = lim / base

  if lim <= base + 9
    mod.zero? ? base * quot : base * mod + quot * base / 10
  else
    10 * base - 1
  end
end

def circular_primes(upper_limit)
  permutation_limit = permutation_limit_estimate(upper_limit)
  primes = Prime.each(permutation_limit).to_set
  primes.select do |p|
    p < LIMIT && circular_permutations(p).all? { |e| primes.include? e }
  end
end

puts circular_primes(231_116).length
puts circular_primes(999_999_999).reduce(1, :*)
