process PICARD {
    container 'community.wave.seqera.io/library/picard:3.4.0--e9963040df0a9bf6'
    input: 
    tuple val(meta), path(genome_file)
    output:
    tuple val(meta), path("${meta}.dict"), emit: dict
    script:  
    """
    picard CreateSequenceDictionary \
    R=${genome_file} \
    O=${meta}.dict
    """
}