require_relative "#{__dir__}/modules/card_parser"
require_relative "#{__dir__}/models/wallet"
FILEPATH       = "#{__dir__}/input.txt"

cards  = CardParser.parse_cards(FILEPATH)
wallet = Wallet.new(cards)

