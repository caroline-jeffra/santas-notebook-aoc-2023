package main

import (
	"bufio"
	"os"
	"strconv"
	"strings"
)

func main() {
	file, _ := os.Open("data.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	lines := []string{}

	for scanner.Scan() {
		line := scanner.Text()
		line = strings.TrimSpace(strings.Split(line, ":")[1])
		lines = append(lines, line)
	}

	timesStrings := strings.Split(lines[0], " ")
	times := removeEmptyAndConvert(timesStrings)

	distancesStrings := strings.Split(lines[1], " ")
	distances := removeEmptyAndConvert(distancesStrings)

	race_results := []int{}

	for time_index, time := range times {
		race_result := 0
		goal := distances[time_index]
		for i := 1; i < time; i++ {
			dps := i
			if (time-i)*dps > goal {
				race_result++
			}

		}
		race_results = append(race_results, race_result)
	}

	output := 1
	for _, result := range race_results {
		output = output * result
	}

	println(output)
}

func removeEmptyAndConvert(arr []string) []int {
	var r []int
	for _, el := range arr {
		if el != "" {
			elNum, _ := strconv.Atoi(el)
			r = append(r, elNum)
		}
	}

	return r
}
