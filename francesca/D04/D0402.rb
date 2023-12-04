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

# SLTN >>> proceed sequentially through keys
def compute_total_cards(wins)
    # wins = [{1=>4}, {2=>2}, {3=>2}, {4=>1}, {5=>0}, {6=>0}]
    # iterate over array
        # win = {1=>4} 
        # get correspective cards & add them to wins
            # PRBL >>> duplicate keys
            # SLTN >>> when ^, store values in array
                # win = {2=>[2,2]}
                # [...]
end

## TEST AREA ##
cards = parse_cards("input.txt")
wins  = compute_wins_per_card(cards)

pp wins