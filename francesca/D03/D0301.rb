class GearRatio
    require 'daru'
    SYM_XP = /[*|#|+|$]/
    
    attr_reader :frame, :sym_positions
    def initialize(txt_path)
        @frame         = parse_to_frame("#{__dir__}/#{txt_path}")
        @sym_positions = find_sym_positions()
    end
    
    private
    
    # => Daru::DataFrame(10x10)
    def parse_to_frame(path)
        scheme = File.open(path).readlines.map { |line| line.chomp.split("") }        
        order  = (0...scheme.size).to_a.map { |i| "col_#{i}" }

        Daru::DataFrame.rows(scheme, order: order)
    end
    
    # => [{:row=>1, :col=>4}, {:row=>3, :col=>7},...]
    def find_sym_positions
        @frame.each_row.with_index.flat_map do |row, row_i|
            row.each_with_index.filter_map do |value, col_i|
                { row: row_i, col: col_i } if value.match?(SYM_XP)
            end
        end
    end
end

## TEST AREA ##
decoder = GearRatio.new("./input.txt")

pp decoder.frame
pp decoder.sym_positions