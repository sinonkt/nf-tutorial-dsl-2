
include "./nbt/utils"

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

process Concat {

  publishDir "${outputPrefixPath(params, task)}/oat"

  input: 
    path results
  
  output:
    path "result.sum.txt"

  script:
  """
  sleep 10
  cat *.txt > result.sum.txt
  """
}


