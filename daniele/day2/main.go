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

	// LOOP FOR GAME
	for scanner.Scan() {
		line := scanner.Text()
		// split on the : to get the id and the rounds as a group
		split := strings.Split(line, ":")
		_, rounds_string := split[0], split[1]
		// split the rounds group on the ; to get the single rounds
		rounds := strings.Split(rounds_string, ";")

		max_color := make(map[string]int)
		max_color["red"] = 0
		max_color["green"] = 0
		max_color["blue"] = 0

		fmt.Println("\nGame: ")

		// LOOP FOR ROUND
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
				if max_color[color] < amount {
					max_color[color] = amount
				}
			}
		}
		set_power := max_color["red"] * max_color["green"] * max_color["blue"]
		// fmt.Println("Possible")
		// id, _ := strconv.Atoi(strings.Split(id_string, " ")[1])
		result += set_power
	}
	fmt.Println(result)
}
