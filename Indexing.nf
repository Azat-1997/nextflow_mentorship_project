process BWA {
    container 'staphb/bwa'
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

workflow {
    genome = Channel.fromPath('genomes/resources_broad_hg38_v0_Homo_sapiens_assembly38.fasta')
    PICARD(genome).dict.view()
}