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

var partOne = 0;
var partTwo = 0;

data.forEach(row => {
  let digitsOne = [];
  let digitsTwo = [];
  [...row].forEach((c, i) => {
    if(!isNaN(c)) {
      digitsOne.push(c);
      digitsTwo.push(c);
    }
    words.forEach((word, n) => {
      if(row.slice(i).startsWith(word)) {
        digitsTwo.push(n+1);
      }
    })
  })
  partOne += +(digitsOne[0] + "" + digitsOne[digitsOne.length - 1]);
  partTwo += +(digitsTwo[0] + "" + digitsTwo[digitsTwo.length - 1]);
})

console.log(partOne);
console.log(partTwo);
