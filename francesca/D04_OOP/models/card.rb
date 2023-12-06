class Card
    attr_reader :id, :wins
    def initialize(id, winning, owned)
        @id              = id
        @winning, @owned = winning, owned
        @wins            = self.compute_wins
    end

    private

    def compute_wins
        (@winning & @owned).count
    end
end