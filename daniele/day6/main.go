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
	time := removeEmptyAndConvert(timesStrings)

	distancesStrings := strings.Split(lines[1], " ")
	distance := removeEmptyAndConvert(distancesStrings)

	race_results := 0

	for i := 1; i < time; i++ {
		dps := i
		if (time-i)*dps > distance {
			race_results++
		}

	}

	println(race_results)
}

func removeEmptyAndConvert(arr []string) int {
	var r []string
	for _, el := range arr {
		if el != "" {
			r = append(r, el)
		}
	}
	numString := strings.Join(r, "")
	num, _ := strconv.Atoi(numString)

	return num
}
