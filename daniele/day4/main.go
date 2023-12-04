package main

import (
	"bufio"
	"fmt"
	"os"
	"slices"
	"strings"
)

func main() {
	file, _ := os.Open("data.txt")
	defer file.Close()
	scanner := bufio.NewScanner(file)

	result := 0
	lines := []string{}

	indexMap := make(map[int]int)

	// Populate the map with keys from 0 to 213 and values set to 1
	for i := 0; i <= 213; i++ {
		indexMap[i] = 1
	}

	for scanner.Scan() {
		line := scanner.Text()
		lines = append(lines, line)
	}

	for line_index, line := range lines {
		card := strings.Split(strings.Split(line, ":")[1], "|")
		winning_nums := strings.Split(card[0], " ")
		winning_nums = delete_empty(winning_nums)

		card_nums := strings.Split(card[1], " ")
		card_nums = delete_empty(card_nums)

		card_score := calculate_score(winning_nums, card_nums)

		for times := 0; times < indexMap[line_index]; times++ {

			// increase the values of the map accordingly
			for i := line_index + 1; i <= line_index+card_score; i++ {
				indexMap[i] = indexMap[i] + 1
			}
		}
	}

	for _, val := range indexMap {
		result += val
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

	return n
}
