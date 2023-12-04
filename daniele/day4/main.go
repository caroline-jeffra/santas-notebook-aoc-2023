package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"slices"
	"strings"
)

func main() {
	file, _ := os.Open("data.txt")
	defer file.Close()
	scanner := bufio.NewScanner(file)

	result := 0

	for scanner.Scan() {
		line := scanner.Text()
		// split the line between the winning numbers and the card numbers
		// split each of them on the space
		// count how many of the card appear in the winning array
		// calculate score and add to result
		card := strings.Split(strings.Split(line, ":")[1], "|")
		winning_nums := strings.Split(card[0], " ")
		winning_nums = delete_empty(winning_nums)

		card_nums := strings.Split(card[1], " ")
		card_nums = delete_empty(card_nums)

		card_score := calculate_score(winning_nums, card_nums)
		result += card_score

		// fmt.Println(winning_nums)
		// fmt.Println(card_nums)
	}

	fmt.Println("Result: ", result)
}

func delete_empty(s []string) []string {
	var r []string
	for _, str := range s {
		if str != "" {
			r = append(r, str)
		}
	}
	return r
}

func calculate_score(winning []string, card []string) int {
	n := 0
	for _, num := range card {
		if slices.Contains(winning, num) {
			n += 1
		}
	}

	if n < 2 {
		return n
	} else {
		// return 2 to the power of n - 1
		return int(math.Pow(float64(2), float64(n-1)))
	}
}
