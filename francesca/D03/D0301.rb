require 'daru'

class GearRatio
    SYMBOLS = %w(* # + $)

    attr_reader :frame, :sym_positions
    def initialize(txt_path)
        @frame         = parse_to_frame("#{__dir__}/#{txt_path}")
        @sym_positions = find_sym_positions()
    end

    private

    # Daru::DataFrame(10x10)
    def parse_to_frame(path)
        scheme = File.open(path).readlines.map { |line| line.chomp.split("") }        
        order  = (0...scheme.size).to_a.map { |i| "col_#{i}" }

        Daru::DataFrame.rows(scheme, order: order)
    end

    # {"*" => [{:row=>1, :col=>"col_3"}, {}, {}], "+"=>[{:row=>5, :col=>"col_5"}],...}
    def find_sym_positions
        positions = {}
    
        SYMBOLS.each do |symbol|
          positions[symbol] = []
          @frame.each_row.with_index do |row, row_i|
            row.each_with_index do |value, col_i|
              positions[symbol] << { row: row_i, col: col_i } if value == symbol
            end
          end
        end
    
        positions
      end
end

## TEST AREA ##
decoder = GearRatio.new("./input.txt")

pp decoder.sym_positions