class GearRatio
    require 'set'

    def initialize(rel_path)
      @scheme = File.open("#{__dir__}/#{rel_path}").read.split("\n")
      @frame  = generate_frame()
    end
    
    def engine_sum
        sum_of_neighbours()
    end
    
    def product_adjacent_pairs
        multiply_pairs()
    end
    
    private
    
    def generate_frame
        @scheme.each_with_object([]) do |line, matrix|
            numbers = line.scan(/(?:\d+|.)/)
            matrix << numbers.flat_map { |number| [number] * number.length }
        end
    end
    
    def sum_of_neighbours
        calculate_engine_sum { |tot, adjacents| tot + adjacents.sum }
    end
    
    def multiply_pairs
        calculate_engine_sum do |tot, adjacents|
            tot + (adjacents.reduce(&:*) if adjacents.size == 2).to_i
        end
    end
    
    def calculate_engine_sum
        @frame.each_with_index.reduce(0) do |tot, (row, idx_x)|
            row.each_with_index do |item, idx_y|
                next if item.scan(/(?:\d|\.)/).first
                
                adjacents = find_adjacent_coords(idx_x, idx_y)
                tot = yield(tot, adjacents)
            end
            tot
        end
    end
    
    def find_adjacent_coords(idx_x, idx_y)
        positions = [0, 1, -1].freeze
        adjacents = positions.each_with_object([]) do |x, tot|
            positions.each { |y| tot << @frame[idx_x + x][idx_y + y].to_i }
        end
        Set.new(adjacents).reject(&:zero?)
    end
end

## TEST AREA ##
path    = "/input.txt"
decoder = GearRatio.new(path)

pp decoder.engine_sum
pp decoder.product_adjacent_pairs