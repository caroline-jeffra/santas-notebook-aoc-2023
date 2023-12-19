#rubocop:disable Metrics

require 'benchmark'
require 'matrix'

Benchmark.bmbm do |x|
  x.report('plain-ole') do
    1_000_000.times do
      a = [1, 2, 3]
      b = [4, 5, 6]
      a[0] += b[0]
      a[1] += b[1]
      a[2] += b[2]
      a
    end
  end
  x.report('each_index') do
    1_000_000.times do
      a = [1, 2, 3]
      b = [4, 5, 6]
      a.each_index { |i| a[i] += b[i] }
    end
  end
  x.report('zip-sum') do
    1_000_000.times do
      a = [1, 2, 3]
      b = [4, 5, 6]
      a.zip(b).map(&:sum)
    end
  end
  x.report('transpose-sum') do
    1_000_000.times do
      a = [1, 2, 3]
      b = [4, 5, 6]
      [a, b].transpose.map(&:sum)
    end
  end
  x.report('map') do
    1_000_000.times do
      a = [1, 2, 3]
      b = [4, 5, 6]
      a.map.with_index { |v, i| v + b[i] }
    end
  end
  x.report('zip-reduce') do
    1_000_000.times do
      a = [1, 2, 3]
      b = [4, 5, 6]
      a.zip(b).map { _1.reduce(&:+) }
    end
  end
  x.report('transpose-reduce') do
    1_000_000.times do
      a = [1, 2, 3]
      b = [4, 5, 6]
      [a, b].transpose.map { _1.reduce(&:+) }
    end
  end
  x.report('vector-initialized') do
    1_000_000.times do
      Vector[1, 2, 3] + Vector[4, 5, 6]
    end
  end
  x.report('vector') do
    1_000_000.times do
      a = [1, 2, 3]
      b = [4, 5, 6]
      Vector.elements(a) + Vector.elements(b)
    end
  end
end
