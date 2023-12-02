MAX_COLORS = { red: 12, green: 13, blue: 14 }

record = "
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
"

def parse_games(str)
    str.strip.split(/\n/).map { |str| str[8..-1].split("; ") }
end

def parse_games_scores(games)
    games.map do |game|
        game.map do |g_str|
            g_str.scan(/(\d+) (\w+)/).map { |value, color| { color => value.to_i } }
        end.flatten
    end
end

def find_possible_games(nested_arr)
    nested_arr.map do |game|
        game.all? do |hash|
            color, value = hash.first
            value <= MAX_COLORS[color.to_sym]
        end
    end
end

def compute_tot_ids(arr)
    arr.each_index.filter_map { |i| i + 1 if arr[i] }.reduce(:+)
end

def find_fewest_cubes(nested_arr)
    nested_arr.map do |game_arr|
        game_arr.each_with_object({}) do |game, max_values|
            game.each { |color, value| max_values[color] = [max_values[color] || 0, value].max }
        end
    end
end

def compute_tot_few(arr)
    arr.map { |few_hsh| few_hsh.values.reduce(:*) }.reduce(:+)
end

games           = parse_games(record)
games_scores    = parse_games_scores(games)

## PART 1 ##
possible_games  = find_possible_games(games_scores)
tot_possible    = compute_tot_ids(possible_games)

## PART 2 ##
fewest_per_game = find_fewest_cubes(games_scores)
power_fewests   = compute_tot_few(fewest_per_game)

p power_fewests