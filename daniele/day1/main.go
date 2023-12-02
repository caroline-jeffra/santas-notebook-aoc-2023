package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
	"strings"
)

func main() {
	numberMap := map[string]string{
		"one":   "o1e",
		"two":   "t2o",
		"three": "t3e",
		"four":  "f4r",
		"five":  "f5e",
		"six":   "s6x",
		"seven": "s7n",
		"eight": "e8t",
		"nine":  "n9e",
	}

	file, err := os.Open("data.txt")
	if err != nil {
		log.Fatal("no file found.")
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	result := 0

	for scanner.Scan() {
		line := scanner.Text()

		fmt.Println(line)
		for substr, replacement := range numberMap {
			line = strings.Replace(line, substr, replacement, -1)
		}
		fmt.Println(line)

		re := regexp.MustCompile("(?:\\d)")

		// array of strings (which are ints)
		numArray := re.FindAllString(line, -1)
		fmt.Println("numarray: ", numArray)

		if len(numArray) == 1 {
			numString := numArray[0]
			fullNumString := numString + numString
			fullNum, _ := strconv.Atoi(fullNumString)
			fmt.Println(fullNum)

			result += fullNum
		} else {
			var first string
			var second string

			first = numArray[0]
			second = numArray[len(numArray)-1]

			fullNumString := first + second
			fullNum, _ := strconv.Atoi(fullNumString)

			fmt.Println(fullNum)
			result += fullNum
		}
	}
	fmt.Println(result)
}
