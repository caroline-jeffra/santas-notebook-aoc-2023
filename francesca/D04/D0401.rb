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

def find_winning_numbers(cards)
    cards.map { |card| card[:winning] & card[:owned] }
end

def compute_total_score(winning_nums)
    winning_nums.map { |score| (score.size > 1) ? 2 ** (score.size - 1) : score.size }.sum
end

## TEST AREA ##
cards        = parse_cards("input.txt")
winning_nums = find_winning_numbers(cards)
card_scores  = compute_total_score(winning_nums)

pp card_scores