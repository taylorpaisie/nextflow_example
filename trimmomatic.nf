#!/usr/bin/env nextflow
// fastqc.nf

nextflow.enable.dsl=2

//Trimmomatic command we are running with this nextflow script
/*
trimmomatic PE {}_1.fastq.gz {}_2.fastq.gz \
{}_pair_1.fastq.gz U_{}_1.fastq.gz \
{}_pair_2.fastq.gz U_{}_2.fastq.gz \
ILLUMINACLIP:/apps/trimmomatic/adapters/TruSeq3-PE-2.fa:2:30:10 \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
*/

nextflow.enable.dsl=2


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

reads_ch = Channel.fromFilePairs("data/untrimmed_fastq/*_{1,2}.fastq.gz")

workflow{
  TRIM(reads_ch)
  TRIM.out.view()
}