const calibrationDoc = `
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
`

// Str > [ '1abc2',...]
const calibrationDocs = (calibrationDoc) => {
  return calibrationDoc.trim().split(/\n/)
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
const valuesOut = calibrationValues(docsOut)
const totalOut = total(valuesOut)

console.log(totalOut)