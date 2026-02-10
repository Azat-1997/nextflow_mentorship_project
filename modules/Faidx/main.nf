process FAIDX {
    tag { meta.id }
    container 'broadinstitute/gatk'
    input: 
    tuple val(meta), path(genome_file)
    output:
    tuple val(meta), path("${genome_file}.fai"), emit: faidx
    script:
    """
    samtools faidx ${genome_file} -o ${genome_file}.fai
    """
}