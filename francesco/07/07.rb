# frozen_string_literal: true

data = File.open('input')
           .read
           .split("\n")
           .map(&:split)
           .map { |(cards, bid)| [cards, bid.to_i] }

def card_value(card)
  case card
  when 'A' then 14
  when 'K' then 13
  when 'Q' then 12
  when 'J' then $part == 2 ? 0 : 11
  when 'T' then 10
  else card.to_i
  end
end

def sort_cards(hand)
  cards = Hash.new(0)
  hand.chars.each { |card| cards[card] += 1 unless card == 'J' && $part == 2 }
  j_count = hand.count('J')
  max = cards.empty? ? 'J' : cards.max_by { |_k, v| v }.first
  cards[max] += j_count if $part == 2

  cards.values.sort
end

def hand_value(hand)
  values = sort_cards(hand)

  case values.last
  when 5 then 6
  when 4 then 5
  when 3 then values[-2] == 2 ? 4 : 3
  when 2 then values[-2] == 2 ? 2 : 1
  else 0
  end
end

def compare_cards(a, b)
  val_a = hand_value(a)
  val_b = hand_value(b)
  return val_a - val_b unless val_a == val_b

  a.length.times do |i|
    diff = card_value(a[i]) - card_value(b[i])
    return diff unless diff.zero?
  end

  0
end

2.times do |t|
  $part = t + 1
  sorted_hands = data.sort { |a, b| compare_cards(a.first, b.first) }
  hand_winnings = sorted_hands.each_with_index
                              .reduce(0) { |sum, ((_c, bid), i)| sum + bid * (i + 1) }
  p hand_winnings
end
