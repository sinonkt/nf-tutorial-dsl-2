nextflow.preview.dsl=2
/*
================================================================================
=                           Sinonkt Style I N I T                              =
================================================================================
*/

params.MAINTAINERS = [
  'Krittin Phornsiricharoenphant (oatkrittin@gmail.com)'
]

include './modules/nbt/utils'

def schema = readAvroSchema("${workflow.projectDir}/schemas/value.avsc")
params = params << getDefaultParams(schema)

include './modules/nbt/log' params(params)
include helpMessage from './modules/nbt/help' params(params)

if (params.version) exit 1, workflowVersionMessage()
if (params.help) exit 1, helpMessage(schema)

/*
================================================================================
=                   Sinonkt Style Workflows definitions                        =
================================================================================
*/
include "./modules/math.nf" params(params)
include "./modules/combine.nf" params(params)

workflow SumOfPower2 {
  get:
    xs
  main:
    Power2(xs)
    Sum(Power2.out.toList())
  emit:
    Sum.out.y
}

workflow SumOfPower3 {
  get:
    xs
  main:
    Power3(xs)
    Sum(Power3.out.toList())
  emit:
    Sum.out.z
}

workflow {
  my_nums = Channel.from(1..params.x)
  if (params.need2) {
    SumOfPower2(my_nums)
    SumOfPower2.out.view()
  } else {
    SumOfPower3(my_nums)
    SumOfPower3.out.view()
  }
  // Power2(my_nums)
  // Power3(my_nums)
  // Power2.out.toList().view()
  // power2odd = Power2.out.filter { it % 2 == 1 }
  // Sum(power2odd.toList())
  // Sum.out.z.view()
  // Sum.out.y.view()
  // Sum.out.z.view()
  // Power2.out.view()
  //  Power3.out.view()
  // Power3()
}