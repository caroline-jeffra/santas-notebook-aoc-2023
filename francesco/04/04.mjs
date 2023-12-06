// https://adventofcode.com/2023/day/4
import { headers } from '../../config.mjs';

const data = await fetch("https://adventofcode.com/2023/day/4/input", headers)
  .then(resp => resp.text())
  .then(text => text.split("\n").slice(0,-1))

var sum = 0;
const copies = {};

data.forEach((card, i) => {
  if(!(i in copies)) copies[i] = 0;
  copies[i] += 1;

  const [winning, scratched] = card.split(": ")[1].split(" | ").map(half => {
    return half.split(/\s+/g).filter(Boolean);
  })

  const hits = scratched.filter(num => winning.includes(num));
  const numHits = hits.length;
  const points = Number.parseInt(2 ** (numHits - 1));

  for(let j = 0; j < numHits; j++) {
    if(!(i + 1 + j in copies)) copies[i + 1 + j] = 0;
    copies[i + 1 + j] += copies[i];
  }
  sum += points;
})

const partOne = sum;
const partTwo = Object.values(copies).reduce((sum, v) => sum + v, 0);

console.log(partOne);
console.log(partTwo);
