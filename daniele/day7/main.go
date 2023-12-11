package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

var part int

func main() {
	file, _ := os.Open("data.txt")
	defer file.Close()

	var data []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		data = append(data, scanner.Text())
	}

	for t := 0; t < 2; t++ {
		part = t + 1
		sort.SliceStable(data, func(i, j int) bool {
			return compareHand(strings.Fields(data[i])[0], strings.Fields(data[j])[0]) < 0
		})

		handWinnings := 0
		for i, line := range data {
			bid, _ := strconv.Atoi(strings.Fields(line)[1])
			handWinnings += (i + 1) * bid
		}

		fmt.Println(handWinnings)
	}
}

func cardValue(card string) int {
	switch card {
	case "A":
		return 14
	case "K":
		return 13
	case "Q":
		return 12
	case "J":
		if part == 2 {
			return 0
		}
		return 11
	case "T":
		return 10
	default:
		return int(card[0] - '0')
	}
}

func sortCards(hand string) []int {
	cards := make(map[rune]int)
	for _, card := range hand {
		if !(card == 'J' && part == 2) {
			cards[card]++
		}
	}
	jCount := strings.Count(hand, "J")
	var max rune
	if len(cards) == 0 {
		max = 'J'
	} else {
		for k, v := range cards {
			if v > cards[max] {
				max = k
			}
		}
	}
	if part == 2 {
		cards[max] += jCount
	}

	var values []int
	for _, v := range cards {
		values = append(values, v)
	}
	sort.Ints(values)
	return values
}

func handValue(hand string) int {
	values := sortCards(hand)

	switch values[len(values)-1] {
	case 5:
		return 6
	case 4:
		return 5
	case 3:
		if values[len(values)-2] == 2 {
			return 4
		}
		return 3
	case 2:
		if values[len(values)-2] == 2 {
			return 2
		}
		return 1
	default:
		return 0
	}
}

func compareHand(a, b string) int {
	valA := handValue(a)
	valB := handValue(b)
	if valA != valB {
		return valA - valB
	}

	for i := 0; i < len(a); i++ {
		diff := cardValue(string(a[i])) - cardValue(string(b[i]))
		if diff != 0 {
			return diff
		}
	}

	return 0
}
