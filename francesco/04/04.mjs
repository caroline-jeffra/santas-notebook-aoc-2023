// https://adventofcode.com/2023/day/4
import { headers } from '../../config.mjs';

const data = await fetch("https://adventofcode.com/2023/day/4/input", headers)
  .then(resp => resp.text())
  .then(text => text.split("\n").slice(0,-1))


const computeSums = (data, start, end, part) => {
  var sum = 0;
  var count = 0;

  const copies = data.slice(start, end);
  copies.forEach((card, i) => {
    const [winning, scratched] = card.split(": ")[1].split(" | ").map(half => {
      return half.split(/\s+/g).filter(Boolean);
    })

    const hits = scratched.filter(num => winning.includes(num));
    const numHits = hits.length;
    if(part == 1) {
      const points = Number.parseInt(2 ** (numHits - 1));
      sum += points
    } else {
      const nextRow = start + i + 1;
      count += 1 + computeSums(data, nextRow, nextRow + numHits, part);
    }
  })

  if (part == 1) return sum
  else return count;
}

const partOne = computeSums(data, 0, data.length, 1);
const partTwo = computeSums(data, 0, data.length, 2);
console.log(partOne);
console.log(partTwo);
