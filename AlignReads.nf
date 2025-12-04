#!/usr/bin/env nextflow

params.container = 'quay.io/biocontainers/bwa:0.7.17--he4a0461_11'    // Docker/Singularity container image
params.task_cpus = 2

process ALIGN {
    container params.container
    tag { pair_id_val }
    input:
    tuple val(pair_id_val), path(read1), path(read2)
    tuple path(genome), path(amb), path(ann), path(bwt), path(pac), path(sa)
    path fai
    path dict 
    output:
    tuple val(pair_id_val), path("${genome.baseName}_${pair_id_val}.sam"), emit: sam
    script:
    """
    bwa mem -t ${params.task_cpus} ${genome} ${read1} ${read2} > ${genome.baseName}_${pair_id_val}.sam
    """
}

