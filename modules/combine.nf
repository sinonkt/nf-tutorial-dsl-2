
process Sum {

  input: 
    val xs

  output:
    val y, emit: y
    val z, emit: z

  exec:
  y = xs.sum()
  z = xs.sum() + 1
}


