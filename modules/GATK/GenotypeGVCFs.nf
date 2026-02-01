process GENOTYPE {
    tag { pair_id_val }
    input:
    path genome
    path index
    path dict
    tuple val(pair_id_val), path(gvcf_index), path(gvcf_file)
    output:
    tuple val(pair_id_val), path("${pair_id_val}.vcf.gz"), path("${pair_id_val}.vcf.gz.tbi"), emit: genotype_gvcf
    script:
    """gatk --java-options "-Xmx4g" GenotypeGVCFs \
   -R ${genome} \
   -V ${gvcf_file} \
   -O ${pair_id_val}.vcf.gz"""
}