process GENOTYPE {
    tag { pair_id_val }
    container 'broadinstitute/gatk'
    input:
    path genome
    tuple val(index_meta), path(index)
    tuple val(dict_meta), path(dict)
    tuple val(pair_id_val), path(gvcf_index), path(gvcf_file)
    output:
    tuple val(pair_id_val), path("${pair_id_val}.vcf.gz"), path("${pair_id_val}.vcf.gz.tbi"), emit: genotype_gvcf
    script:
    """gatk --java-options "-Xmx4g" GenotypeGVCFs \
   -R ${genome} \
   -V ${gvcf_file} \
   -O ${pair_id_val}.vcf.gz"""
}