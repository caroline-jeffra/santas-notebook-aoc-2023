// https://adventofcode.com/2023/day/2
import { headers } from '../../config.mjs';

const data = await fetch("https://adventofcode.com/2023/day/2/input", headers)
  .then(resp => resp.text())
  .then(text => text.split("\n").slice(0,-1))

const games = data.map(l => l.split(": ")[1].split(/[;,] /).map(numCol => {
    const [num, col] = numCol.split(" ")
    return ({ col, num: +num })
}))

const max = {
    red: 12,
    green: 13,
    blue: 14
}

var sum = 0;
var totalPower = 0;

games.forEach((game, gameid) => {
  if(game.every(item => item.num <= max[item.col])) {
    sum += gameid + 1
  }

  var largest = {
    red: 0,
    green: 0,
    blue: 0
  }

  game.forEach(item => {
    if(item.num > largest[item.col]) {
      largest[item.col] = item.num;
    }
  })

  totalPower += (largest.red * largest.green * largest.blue)

})

console.log(sum);
console.log(totalPower);

