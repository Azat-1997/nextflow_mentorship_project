process GENOTYPE {
    tag { meta.id }
    container 'broadinstitute/gatk'
    input:
    path genome
    tuple val(index_meta), path(index)
    tuple val(dict_meta), path(dict)
    tuple val(meta), path(gvcf_index), path(gvcf_file)
    output:
    tuple val(meta), path("${meta.id}.vcf.gz"), path("${meta.id}.vcf.gz.tbi"), emit: genotype_gvcf
    script:
    """gatk --java-options "-Xmx4g" GenotypeGVCFs \
   -R ${genome} \
   -V ${gvcf_file} \
   -O ${meta.id}.vcf.gz"""
}