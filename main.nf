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

// workflow SumOfPower2 {
//   get:
//     xs
//   main:
//     Power2(xs)
//     Sum(Power2.out.toList())
//   emit:
//     Sum.out.y
// }

// workflow SumOfPower3 {
//   get:
//     xs
//   main:
//     Power3(xs)
//     Sum(Power3.out.toList())
//   emit:
//     Sum.out.z
// }


// workflow Proton {
//   get: files
//   main:
//     Concat(files)
// }
process MyFastQBam {

  tag { chr }

  input:
  set sampleId, file(fastq), file(bam)
  each chrPos
  // each ref

  script:
  (chr, pos) = chrPos
  println (chr)
  println (pos)
  """
  ls
  """
}

workflow {
  fastqs = Channel.fromPath("/tarafs/biobank/bio0001-human/GeTH/FASTQ/HS06/*/*.{fq,fastq}.gz").map { [ it.parent.name, it ] }
  bams = Channel.fromPath("/tarafs/biobank/bio0001-human/GeTH/BAM/HS06/*/*.bam").map { [ it.parent.name, it ] }
  // ref = Channel.fromPath("/tarafs/biobank/data/share/pachyderm/variant-calling-toolkit/references/human/ucsc_hg19/ucsc.hg19.fa").first()
  chrs = Channel.from(["chr1", "pos1"], ["chr2", "pos2"], ["chr3", "pos3"])
  // refs = Channel.from("ref1", "ref2")
  // bams.view()
  merged = fastqs.join(bams)
  // combined = merged.combine(chrs)
  // combined.view()
  MyFastQBam(merged, chrs)
  // right= Channel.from(['Z', 6], ['Y', 5], ['X', 4], ['X', 5])
  // left.join(right).view()
  // xs = Channel.from(1..params.x)
  // ys = Channel.from(1..params.y)

  // xs.product(ys).view()
  // Power2(my_nums)
  // Power2.out.result.view()
  // (Result, Original) = Power2.out
  // Proton(Result.toList())
  // Original.view()
  // Result.view()
  // if (params.need2) {
  //   SumOfPower2(my_nums)
  //   SumOfPower2.out.view()
  // } else {
  //   SumOfPower3(my_nums)
  //   SumOfPower3.out.view()
  // }
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