// https://adventofcode.com/2023/day/3
import { headers } from '../../config.mjs';

const data = await fetch("https://adventofcode.com/2023/day/3/input", headers)
  .then(resp => resp.text())
  .then(text => text.split("\n").slice(0,-1))

const characters = data.map(line => line.split(''))

const rows = characters.length
const columns = characters[0].length

var partNumbers = [];
const gearRatios = [];

const getAdjacentNumbers = (r, c) => {
  var adjacent = [];
  for(let rr = r - 1; rr <= r + 1; rr++) {
    const row = data[rr];
    const matchedNums = [...row.matchAll(/\d+/g)];
    matchedNums.forEach(match => {
      if(c >= match.index - 1 && c <= match.index + match[0].length) {
        adjacent.push(+match[0]);
      } 
    })
  }

  return adjacent;
}

for(let r = 0; r < rows; r++) {
  for(let c = 0; c < columns; c++) {
    if(characters[r][c].match(/[^\d.]/)) {
      let numbers = getAdjacentNumbers(r, c);
      partNumbers = partNumbers.concat(numbers);
      if(characters[r][c] == "*" && numbers.length == 2) {
        gearRatios.push(numbers[0] * numbers[1])
      }
    }
  }
}

const sum = partNumbers.reduce((sum, num) => sum + num, 0);
const totalGearRations = gearRatios.reduce((sum, num) => sum + num, 0);

console.log(sum);
console.log(totalGearRations);
