process PICARD {
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