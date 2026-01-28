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