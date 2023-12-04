package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

func main() {
	file, _ := os.Open("data.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)

	lines := []string{}
	result := 0

	for scanner.Scan() {
		line := scanner.Text()
		lines = append(lines, line)
	}

	for line_index, line := range lines {
		re := regexp.MustCompile(`\d+`)
		line_nums := re.FindAllStringIndex(line, -1)
		fmt.Println(line)
		for _, num := range line_nums {
			if checkAdjacent(num, line_index, lines) {

				numString := line[num[0]:num[1]]
				numInt, _ := strconv.Atoi(numString)
				fmt.Println(numInt)
				result += numInt
			}
		}
	}

	fmt.Println("Result: ", result)
}

func checkAdjacent(coord []int, index int, lines []string) bool {
	// checks all adjacent positions and returns true or false
	regex := `[^\.\d]`
	before := coord[0] - 1
	after := coord[1]
	if before >= 0 {
		char_before := string(lines[index][before])
		if symbol, _ := regexp.MatchString(regex, char_before); symbol {
			return true
		}
	}

	if after <= 139 {
		char_after := string(lines[index][after])
		if symbol, _ := regexp.MatchString(regex, char_after); symbol {
			return true
		}
	}

	index_before := index - 1
	if index_before > 0 {
		line_before := lines[index_before]
		var start int
		var end int

		if coord[0]-1 < 0 {
			start = coord[0]
		} else {
			start = coord[0] - 1
		}

		if coord[1]+1 > 139 {
			end = coord[1]
		} else {
			end = coord[1] + 1
		}

		slice := line_before[start:end]
		if symbol, _ := regexp.MatchString(regex, slice); symbol {
			return true
		}
	}

	index_after := index + 1
	if index_after < 140 {
		fmt.Println("I'm HERE!")
		line_after := lines[index_after]

		var start int
		var end int

		if coord[0]-1 < 0 {
			start = coord[0]
		} else {
			start = coord[0] - 1
		}

		if coord[1]+1 > 139 {
			end = coord[1]
		} else {
			end = coord[1] + 1
		}

		slice := line_after[start:end]
		fmt.Println(slice)
		if symbol, _ := regexp.MatchString(regex, slice); symbol {
			return true
		}
	}
	return false
}
