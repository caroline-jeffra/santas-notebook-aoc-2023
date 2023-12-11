require_relative "#{__dir__}/../models/card"

module CardParser
    extend self
    def parse_cards(filepath)
        File.open(filepath).each_line.map.with_index do |line, idx|
            game           = line.chomp.split(/\: /).last.split(/\s\|\s/)
            winning, owned = process_card_slice(game.first), process_card_slice(game.last)
            
            { id: idx+1, winning: winning, owned: owned }
        end => flat_cards
        self.create_cards(flat_cards)
    end

    def process_card_slice(slice)
        slice.split(/\s/).map(&:to_i).reject(&:zero?)
    end

    def create_cards(flat_cards)
        return flat_cards.map { |card| Card.new(card[:id], card[:winning], card[:owned]) }
    end
end