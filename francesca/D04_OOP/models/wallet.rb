class Wallet
    attr_reader :cards_count
    def initialize(cards)
        @cards       = cards
        @card_copies = self.set_copies_map
        @cards_count = self.compute_total_cards
    end

    private

    def compute_total_cards; end

    def set_copies_map
        @cards.map do |card|
            { card.id => 1 }
        end
    end
end