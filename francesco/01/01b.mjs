// https://adventofcode.com/2023/day/1
import { headers } from '../../config.mjs';

const data = await fetch("https://adventofcode.com/2023/day/1/input", headers)
  .then(resp => resp.text())
  .then(text => text.split("\n").slice(0,-1))

const words = [
  'one',
  'two',
  'three',
  'four',
  'five',
  'six',
  'seven',
  'eight',
  'nine',
];

const getNum = (str) => {  
  return str.length == 1 ? str : words.indexOf(str) + 1
}

const reFirst = new RegExp(`(\\d|${words.join('|')})`);
const reLast = new RegExp(`.*(\\d|${words.join('|')})`);
var partOne = 0;
var partTwo = 0;

data.forEach(row => {
  const firstP1 = row.match(/(\d)/)[1]
  const lastP1 = row.match(/.*(\d)/)[1]
  const firstP2 = row.match(reFirst)[1]
  const lastP2 = row.match(reLast)[1]
  partOne += +(firstP1 + lastP1);
  partTwo += +(getNum(firstP2) + "" + getNum(lastP2));
})

console.log(partOne);
console.log(partTwo);
