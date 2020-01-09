
process Power2 {

  tag { "oat_${a}" }

  input: 
  val a

  output: 
  path "result.*.txt"
  val a

  script:
  """
  sleep 10
  echo "${a ** 2}" > result.${a}.txt
  """
}

process Power3 {

  tag { "oat_${a}" }

  input: val a

  output:
  set file("result.txt"), file(".command*")

  script:
  """
  echo "${a ** 3}" > result.txt
  """
}