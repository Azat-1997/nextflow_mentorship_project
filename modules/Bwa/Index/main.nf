process BWA_INDEX {
    tag { meta.id }
    container 'staphb/bwa'
    input:
    tuple val(meta), path(genome_file)
    output:
    tuple val(meta), path("bwa"), emit: bwa_index
    script: 
    """
    mkdir bwa
    bwa index -p bwa/${genome_file.baseName} ${genome_file}
    """
}