package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	file, _ := os.Open("data.txt")
	defer file.Close()
	scanner := bufio.NewScanner(file)

	result := 0

	for scanner.Scan() {
		// split the line on spaces and make it into slice of ints
		// call recursive function to get value
		// sum to result
		line := scanner.Text()
		lineNums := convertLine(line)
		value := calculateValue(lineNums)
		result += value
	}

	fmt.Println("Result: ", result)
}

func calculateValue(nums []int) int {
	// get the difference between the numbers and make a new slice
	// if the slice is all zeroes it's the bottom, return sum (0 for first case)
	// if nums[len(nums)-1] == 0 {
	// 	return 0
	// }

	baseCase := true
Check:
	for _, num := range nums {
		if num != 0 {
			baseCase = false
			break Check
		}
	}

	if baseCase {
		return 0
	}

	newSlice := makeNewSlice(nums)
	sum := calculateValue(newSlice)
	return sum + nums[len(nums)-1]
}

func convertLine(line string) []int {
	split := strings.Split(line, " ")
	result := []int{}
	for _, n := range split {
		num, _ := strconv.Atoi(n)
		result = append(result, num)
	}
	return result
}

func makeNewSlice(nums []int) []int {
	newSlice := []int{}
	for i := 0; i < len(nums)-1; i++ {
		newNum := nums[i+1] - nums[i]
		newSlice = append(newSlice, newNum)
	}
	return newSlice
}
