process FAIDX {
    container 'broadinstitute/gatk'
    input: 
    tuple val(meta), path(genome_file)
    output:
    tuple val(meta), path("${meta}.fai"), emit: faidx
    script:
    """
    samtools faidx ${genome_file} -o ${meta}.fai
    """
}