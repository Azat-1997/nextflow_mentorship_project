genome_file = Channel.fromPath("genomes/mm9.fasta")
picard = '../picard.jar'
process BWA {
    container 'staphb/bwa'
    publishDir "${params.outdir}/BWA"
    input:
    path genome_file
    output:
    path "${genome_file}"
    path "${genome_file}.amb"
    path "${genome_file}.ann"
    path "${genome_file}.bwt"
    path "${genome_file}.pac"
    path "${genome_file}.sa"
    script: 
    """
    bwa index ${genome_file}
    """
    
}

process FAIDX {
    container 'broadinstitute/gatk'
    publishDir "${params.outdir}/BWA"
    input: 
    path genome_file
    output:
    path "${genome_file}.fai"
    script:
    """
    samtools faidx ${genome_file}
    """
}

process PICARD {
    container 'community.wave.seqera.io/library/picard:3.4.0--e9963040df0a9bf6'
    publishDir "${params.outdir}/BWA", mode: 'copy'
    input: 
    path genome_file
    output:
    "*.dict"
    script:  
    """
    picard CreateSequenceDictionary \
    R=${genome_file}
    O=${genome_file}.dict
    """
}

workflow {
    BWA(genome_file);
    FAIDX(genome_file);
    PICARD(genome_file);
}