package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

// 12 red, 13 green 14 blue
// sum the IDs of the possible games
func main() {
	file, _ := os.Open("data.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)

	colors := make(map[string]int)
	colors["red"] = 12
	colors["green"] = 13
	colors["blue"] = 14

	result := 0
Game:
	for scanner.Scan() {
		line := scanner.Text()
		// split on the : to get the id and the rounds as a group
		split := strings.Split(line, ":")
		id_string, rounds_string := split[0], split[1]
		// split the rounds group on the ; to get the single rounds
		rounds := strings.Split(rounds_string, ";")

		fmt.Println("\nGame: ")
		for _, round := range rounds {
			fmt.Println("Round: ", round)
			// split the single rounds on the , to get the colors
			color_draw := strings.Split(round, ",")
			for _, color_amount := range color_draw {
				// split the single color on the space to get the amount and the color
				s := strings.Split(strings.TrimSpace(color_amount), " ")
				str_amount, color := strings.TrimSpace(s[0]), strings.TrimSpace(s[1])
				fmt.Println("Color: ", color)
				amount, _ := strconv.Atoi(str_amount)
				if colors[color] < amount {
					// if any amount exceeds the threshold, break
					fmt.Println("Impossible")
					continue Game
				}
			}
		}
		// if you get to the end, add id to the total
		fmt.Println("Possible")
		id, _ := strconv.Atoi(strings.Split(id_string, " ")[1])
		result += id
	}
	fmt.Println(result)
}
