require 'matrix'

def parse_galaxies(filepath)
    File.open("#{__dir__}/#{filepath}").each_line.map do |line|
        line.chomp.split("")
    end => raw
    Matrix[*raw]
end

class Matrix
    def is_empty?(char) = char.match?(/\./)
    def all_empty?(arr) = arr.all? { |char| is_empty?(char) }

    def empty_rows = (0...row_count).select { |idx| self.all_empty?(row(idx).to_a) }
    def empty_cols = (0...column_count).select { |idx| self.all_empty?(column(idx).to_a) }
    
    def insert_row_at_index(idx, new_row)
        rows = to_a
        rows.insert(idx, new_row)
        Matrix[*rows]
    end

    def insert_column_at_index(idx, new_col)
        cols    = column_vectors.map(&:to_a)
        new_col = new_col.to_a.slice(0, row_count) + Array.new(row_count - new_col.size, ".")

        cols.insert(idx, new_col)
        Matrix.columns(cols)
    end

    def expand_cosmos
        new_matrix            = self
        empty_rows,empty_cols = self.empty_rows, self.empty_cols

        empty_rows.each_with_index do |idx, i|
            new_row    = Vector[*Array.new(column_count, ".")]
            new_matrix = new_matrix.insert_row_at_index(idx, new_row)

            empty_rows[i+1] += 1 unless empty_rows[i+1].nil?
        end

        empty_cols.each_with_index do |idx, i|
            new_col = Vector[*Array.new(row_count, ".")]
            new_matrix = new_matrix.insert_column_at_index(idx, new_col)

            empty_cols[i+1] += 1 unless empty_cols[i+1].nil?
        end
        return new_matrix
    end
end

## TEST AREA ##
galaxies_matrix = parse_galaxies("input.txt")
pp galaxies_matrix

galaxies_matrix = galaxies_matrix.expand_cosmos
pp galaxies_matrix.column(9)