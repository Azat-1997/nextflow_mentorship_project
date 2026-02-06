process PICARD {
    container 'community.wave.seqera.io/library/picard:3.4.0--e9963040df0a9bf6'
    input: 
    path genome_file
    output:
    path "${genome_file.baseName}.dict", emit: dict
    script:  
    """
    picard CreateSequenceDictionary \
    R=${genome_file} \
    O=${genome_file.baseName}.dict
    """
}