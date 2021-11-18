exports.sumBigNumber = (str1, str2) => {
  // swap if str2 > str1
  if (str2.length > str1.length) {
      let tmp = str1
      str1 = str2
      str2 = tmp
  }
  const str1Length = str1.length
  const str2Length = str2.length
  const maxLength = Math.max(str1Length, str2Length)
  let carry = 0, total = ''
  for (let i = 1; i <= maxLength; i++) {
      let a = +str1.charAt(str1Length - i)
      let b = +str2.charAt(str2Length - i)
      let strCarry = carry > 0 ? ' + ' + carry : ''
      let t = carry + a + b
      carry = t/10 |0
      console.log(`Step ${i}: ${a} + ${b} ${strCarry} = ${t} , write ${ t %= 10 } ${carry > 0 ? 'remember: ' + carry : ''}`)
      t %= 10
      total = ( (i === maxLength && carry) ? carry*10 + t : t) + total
  }
  if (carry) {
      console.log(`write ${carry}`)
  }
  return total
}