require 'matrix'

def parse_galaxies(filepath)
    File.open("#{__dir__}/#{filepath}").each_line.map do |line|
        line.chomp.split("")
    end => raw
    Matrix[*raw]
end

class Matrix
    def all_empty?(arr) = arr.all? { |char| char.match?(/\./) }
    def empty_rows      = (0...row_count).select { |idx| all_empty?(row(idx).to_a) }
    def empty_cols      = (0...column_count).select { |idx| all_empty?(column(idx).to_a) }

    def insert_row_at_index(idx, new_row)
        rows = self.to_a
        rows.insert(idx, new_row)
        Matrix[*rows]
    end

    def insert_column_at_index(idx, new_col)
        cols    = column_vectors.map(&:to_a)
        new_col = new_col.to_a.slice(0, self.row_count) + Array.new(self.row_count - new_col.size, ".")

        cols.insert(idx, new_col)
        Matrix.columns(cols)
    end

    def expand_cosmos
        new_matrix            = self
        empty_rows,empty_cols = self.empty_rows, self.empty_cols

        empty_rows.each_with_index do |idx, i|
            new_row    = Vector[*Array.new(column_count, ".")]
            new_matrix = new_matrix.insert_row_at_index(idx+1, new_row)

            empty_rows[i+1] += 1 unless empty_rows[i+1].nil?
        end

        empty_cols.each_with_index do |idx, i|
            new_col    = Vector[*Array.new(row_count, ".")]
            new_matrix = new_matrix.insert_column_at_index(idx+1, new_col)

            empty_cols[i+1] += 1 unless empty_cols[i+1].nil?
        end
        return new_matrix
    end

    def assign_galaxy_id
        id = 0
        self.to_a.map do |row|
          row.map do |char|
            id += 1 if char.match?(/\#/)
            char.match?(/\#/) ? id : char 
          end
        end => rows
        Matrix[*rows]
    end

    def galaxies_ids
        last = self.count { |char| char.class == Integer }
        (1..last).to_a
    end

    def shortest_paths_sum
        pairs  = self.galaxies_ids.combination(2).to_a

        pairs.map do |point1, point2|
            coords1, coords2 = self.index(point1), self.index(point2)
            (coords1[0] - coords2[0]).abs + (coords1[1] - coords2[1]).abs
        end.flatten.sum
    end
end

## TEST AREA ##
expanded_universe  = parse_galaxies("input.txt").expand_cosmos.assign_galaxy_id
shortest_paths_sum = expanded_universe.shortest_paths_sum
pp shortest_paths_sum