package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strings"
)

func main() {
	file, _ := os.Open("data.txt")
	defer file.Close()
	scanner := bufio.NewScanner(file)
	re := regexp.MustCompile(`([A-Z])\w+`)

	nodes := make(map[string][]string)
	lines := []string{}

	for scanner.Scan() {
		line := scanner.Text()
		lines = append(lines, line)
	}

	directions := lines[0]

	for _, line := range lines[2:] {
		// divide the line, the left is the key of the map, the right is the value, so an array
		s := strings.Split(line, "=")
		key := strings.TrimSpace(s[0])
		value := re.FindAllString(s[1], -1)
		nodes[key] = value
	}

	result := 0
	current := "AAA"

Head:
	for {
		for _, dir := range directions {
			if dir == 'L' {
				current = nodes[current][0]
			} else {
				current = nodes[current][1]
			}
			result++
			if current == "ZZZ" {
				break Head
			}
		}
	}

	fmt.Println("Result: ", result)
}
