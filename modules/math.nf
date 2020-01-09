
process Power2 {

  tag { "oat_${a}" }

  input: val a

  output: val b

  exec:
  b = a ** 2
}

process Power3 {

  tag { "oat_${a}" }

  input: val a

  output: val b

  exec:
  b = a ** 3
}