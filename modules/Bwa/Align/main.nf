#!/usr/bin/env nextflow

process BWA_ALIGN {
    tag { pair_id_val }
    container 'quay.io/biocontainers/bwa:0.7.17--he4a0461_11'
    input:
    tuple val(pair_id_val), path(read1), path(read2)
    path(genome)
    tuple val(meta), path(bwa_index)
    output:
    tuple val(pair_id_val), path("${genome.baseName}_${pair_id_val}.sam"), emit: sam
    script:
    """
    bwa mem -t ${task.cpus} ${bwa_index}/${meta} ${read1} ${read2} > ${genome.baseName}_${pair_id_val}.sam
    """
}

