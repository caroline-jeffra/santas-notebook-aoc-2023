const calibrationDoc = `
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
`

// Str > [ '1abc2',...]
const calibrationDocs = (calibrationDoc) => {
  return calibrationDoc.trim().split(/\n/)
}

// [ 'two1nine',...] > [ '219',...]
const calibrationSub = (docs) => {
  const charToNum = {
    'one': 'o1e',
    'two': 'tw2o',
    'three': 't3e',
    'four': 'f4r',
    'five': 'fi5ve',
    'six': 'si6x',
    'seven': '7n',
    'eight': 'eig8th',
    'nine': '9e',
    'zero': '0o'
  }

  return docs.map((doc) => {
    let subbed = doc
    Object.entries(charToNum).map(([char, num]) => {
      const regex = new RegExp(char, 'ig')
      subbed = subbed.replace(regex, num)
    })
    return subbed
  })
}

// [ '1abc2',...] > [[ 1, 2 ],...] > [ 12, 38,...]
const calibrationValues = (docs) => {
  let values = docs.map((docStr) => docStr.match(/\d/g))
  return values.map((value) => 
    +`${value[0]}${value[value.length - 1] ? value[value.length - 1] : value[0]}`
  )
}

// [ 12, 38,...] > 142
const total = (values) => {
  return values.reduce((total, current) => total + current, 0)
}

//// TEST AREA ////
const docsOut = calibrationDocs(calibrationDoc)
const valuesOut = calibrationValues(calibrationSub(docsOut))
const totalOut = total(valuesOut)


console.log(calibrationSub(docsOut))
console.log(valuesOut)
console.log(totalOut)