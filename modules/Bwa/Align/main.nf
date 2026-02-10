#!/usr/bin/env nextflow

process BWA_ALIGN {
    tag { meta.id }
    container 'quay.io/biocontainers/bwa:0.7.17--he4a0461_11'
    input:
    tuple val(meta), path(read1), path(read2)
    tuple val(genome_meta), path(genome)
    tuple val(index_meta), path(bwa_index)
    output:
    tuple val(meta), path("${genome.baseName}_${meta.id}.sam"), emit: sam
    script:
    """
    bwa mem -t ${task.cpus} ${bwa_index}/${index_meta.id} ${read1} ${read2} > ${genome.baseName}_${meta.id}.sam
    """
}

