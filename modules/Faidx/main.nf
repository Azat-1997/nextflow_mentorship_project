process FAIDX {
    container 'broadinstitute/gatk'
    input: 
    path genome_file
    output:
    path "${genome_file}.fai", emit: faidx
    script:
    """
    samtools faidx ${genome_file}
    """
}