def process_game_part(game_part)
    game_part.split(/\s/).map(&:to_i).reject(&:zero?)
end

def parse_cards(filepath)
    File.open("#{__dir__}/#{filepath}").each_line.map do |line|
        game           = line.chomp.split(/\: /).last.split(/\s\|\s/)
        winning, owned = process_game_part(game.first), process_game_part(game.last)

        { winning: winning, owned: owned }
    end
end

def compute_wins_per_card(cards)
    cards.map.with_index { |card, idx| { idx+1 => [(card[:winning] & card[:owned]).size] } }
end

def compute_total_cards(wins)
    wins.each do |card|
        key   = card.keys.first
        value = card[key].flatten.sum

        new_cards  = wins[key..value]
        new_cards.each do |new_card|
            id  = new_card.keys.first
            idx = id - 1
            wins[idx][id] = ([wins[idx][id]] + [new_card[id]]).flatten
        end
    end.flat_map { |hash| hash.values }.flatten.sum
end

## TEST AREA ##
cards     = parse_cards("input.txt")
wins      = compute_wins_per_card(cards)
tot_cards = compute_total_cards(wins)

pp tot_cards