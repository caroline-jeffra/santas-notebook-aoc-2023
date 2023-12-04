require 'pry-byebug'

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
    cards.map.with_index { |card, idx| { idx+1 => (card[:winning] & card[:owned]).size } }
end

# wins = [{1=>4}, {2=>2}, {3=>2}, {4=>1}, {5=>0}, {6=>0}]
def compute_total_cards(wins)
    begin
        wins.each do |card|
            # win = {1=>4}

            next_upper = card.keys.first
            next_lower = card[next_upper]
            new_cards  = wins[next_upper..next_lower]
            # new_cards = {2=>2}, {3=>2}, {4=>1}, {5=>0}
            
            new_cards.each do |new_card|
                # new_card = {2=>2}
                id  = new_card.keys.first
                idx = id - 1
                wins[idx][id] = [wins[idx][id]] + [new_card[id]]
            end
        end
        # win = {2=>[2,2]}
    rescue ArgumentError => e
        return wins
    end
end

## TEST AREA ##
cards = parse_cards("input.txt")
wins  = compute_wins_per_card(cards)

p compute_total_cards(wins)
# => [{1=>4}, {2=>[2, 2]}, {3=>[2, 2]}, {4=>[1, 1]}, {5=>[0, 0]}, {6=>0}]