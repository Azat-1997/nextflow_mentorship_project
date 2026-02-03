#!/usr/bin/env nextflow

process ALIGN {
    tag { pair_id_val }
    input:
    tuple val(pair_id_val), path(read1), path(read2)
    path(genome)
    tuple path(amb), path(ann), path(bwt), path(pac), path(sa)
    path fai
    path dict 
    output:
    tuple val(pair_id_val), path("${genome.baseName}_${pair_id_val}.sam"), emit: sam
    script:
    """
    bwa mem -t ${task.cpus} ${genome} ${read1} ${read2} > ${genome.baseName}_${pair_id_val}.sam
    """
}

