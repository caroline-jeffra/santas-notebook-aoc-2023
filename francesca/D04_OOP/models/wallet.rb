class Wallet
    attr_reader :cards_count, :card_copies
    def initialize(cards)
        @cards       = cards
        @card_copies = self.set_copies_map
        @cards_count = self.compute_total_cards
    end

    private

    def compute_total_cards
        self.update_card_copies
    end

    def update_card_copies
        @cards.each do |card|
            id, wins = card.id, card.wins
            p id, wins
        end
    end

    def set_copies_map
        @cards.map do |card|
            { card.id => 1 }
        end
    end
end