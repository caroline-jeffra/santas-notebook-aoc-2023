MAX_COLORS = { red: 12, green: 13, blue: 14 }

record = "
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
"

def compute_games(str)
  str.strip.split(/\n/).map { |str| str[8..-1].split("; ") }
end

def compute_games_scores(games)
  games.map do |game|
    game.map do |g_str|
      g_str.scan(/(\d+) (\w+)/).map { |qty, col| { col => qty } }
    end.flatten
  end
end

def find_possible_games(nested_arr)
  nested_arr.map do |game|
    game.all? do |hash|
      color, value = hash.first
      value.to_i <= MAX_COLORS[color.to_sym]
    end
  end
end

def compute_tot_ids(arr)
  arr.each_index.filter_map { |i| i + 1 if arr[i] }.reduce(:+)
end

games          = compute_games(record)
games_scores   = compute_games_scores(games)
possible_games = find_possible_games(games_scores)
total_output   = compute_tot_ids(possible_games)

p total_output