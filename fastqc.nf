#!/usr/bin/env nextflow
// fastqc.nf

nextflow.enable.dsl=2


process FASTQC {
  publishDir "data/untrimmed_fastq/"


  input:
  tuple val(sample_id), path(reads)

  output:
  tuple val(sample_id), path("${sample_id}_fastqc_out")

  script:
  """
  mkdir ${sample_id}_fastqc_out
  fastqc $reads -o ${sample_id}_fastqc_out
  """
}

reads_ch = Channel.fromFilePairs("data/untrimmed_fastq/*_{1,2}.fastq.gz")

workflow{
  FASTQC(reads_ch)
  FASTQC.out.view()
}