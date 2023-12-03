class GearRatio
    require 'daru'
    SYM_XP = /[*|#|+|$]/
    
    attr_reader :frame, :symbols_coords, :proximity_coords
    def initialize(txt_path)
        @frame            = parse_to_frame("#{__dir__}/#{txt_path}")
        @symbols_coords   = find_symbols_coordinates()
        @proximity_coords = compute_proximity_coordinates()
    end
    
    private
    
    # @frame => Daru::DataFrame(10x10) xx @.row[0] xx @["col_0"]
    def parse_to_frame(path)
        scheme = File.open(path).readlines.map { |line| line.chomp.split("") }        
        order  = (0...scheme.size).to_a.map { |i| "col_#{i}" }
        
        Daru::DataFrame.rows(scheme, order: order)
    end
    
    # @symbols_coords => [{:row=>1, :col=>"col_3"}, {:row=>3, :col=>"col_6"},...]
    def find_symbols_coordinates
        @frame.each_row.with_index.flat_map do |row, row_i|
            row.each_with_index.filter_map do |value, col_i|
                { row: row_i, col: col_i } if value.match?(SYM_XP)
            end
        end
    end
    
    # @proximity_coords => [{:row=>0, :col=>"col_2"}, {:row=>0, :col=>"col_3"},...]
    def compute_proximity_coordinates
        @symbols_coords.flat_map { |cell| generate_neighbors(cell[:row], cell[:col]) }
    end
    
    def generate_neighbors(row, col)
        col_number = col.split('_').last.to_i
        offsets = [-1, 0, 1]
        
        offsets.product(offsets).map do |row_offset, col_offset|
            next if row_offset == 0 && col_offset == 0
            
            { row: row + row_offset, col: "col_#{col_number + col_offset}" }
        end.compact
    end
end

## TEST AREA ##
decoder = GearRatio.new("./input.txt")
pp decoder.proximity_coords