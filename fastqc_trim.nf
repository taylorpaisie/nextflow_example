#!/usr/bin/env nextflow
// fastqc_trim.nf

nextflow.enable.dsl=2

process FASTQC {
  publishDir "data/untrimmed_fastq/"


  input:cd 
  tuple val(sample_id), path(reads)

  output:
  tuple val(sample_id), path("${sample_id}_fastqc_out")

  script:
  """
  mkdir ${sample_id}_fastqc_out
  fastqc $reads -o ${sample_id}_fastqc_out
  """
}

process TRIM {
  publishDir "data/trimmed_fastq/"


  input:
  tuple val(sample_id), path(reads)

  output:
  tuple val(sample_id), path("trim_${sample_id}_1.fastq.gz"), 
  path("trim_${sample_id}_2.fastq.gz")

  script:
  """
  trimmomatic PE ${reads[0]} ${reads[1]} \
  trim_${reads[0]} U_${reads[0]} \
  trim_${reads[1]} U_${reads[1]} \
  ILLUMINACLIP:~/bin/NexteraPE-PE.fa:2:30:10 \
  LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
  """
}

workflow{
  TRIM(reads_ch)
  TRIM.out.view()
}