process GENOTYPE {
    tag { meta.id }
    container 'broadinstitute/gatk'
    input:
    tuple val(genome_meta), path(genome), path(fai), path(dict)
    tuple val(meta), path(gvcf_file), path(gvcf_index)
    output:
    tuple val(meta), path("${meta.id}.vcf.gz"), emit: genotype_gvcf
    script:
    """gatk --java-options "-Xmx4g" GenotypeGVCFs \
   -R ${genome} \
   -V ${gvcf_file} \
   -O ${meta.id}.vcf.gz"""
}