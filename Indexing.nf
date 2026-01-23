process BWA {
    input:
    path genome_file
    output:
    tuple path("${genome_file}.amb"), 
          path("${genome_file}.ann"), 
          path("${genome_file}.bwt"), 
          path("${genome_file}.pac"), 
          path("${genome_file}.sa"), emit: bwa_index
    script: 
    """
    bwa index ${genome_file}
    """
}

process FAIDX {
    input: 
    path genome_file
    output:
    path "${genome_file}.fai", emit: faidx
    script:
    """
    samtools faidx ${genome_file}
    """
}

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