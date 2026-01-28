process GENOTYPE {
    tag { pair_id_val }
    input:
    tuple val(pair_id_val), path(gvcf_file), path(gvcf_index)
    path genome_file
    path genome_index
    path genome_dict
    output:
    tuple val(pair_id_val), path("${pair_id_val}.vcf.gz"), path("${pair_id_val}.vcf.gz.tbi"), emit: genotype_gvcf
    script:
    """gatk --java-options "-Xmx4g" GenotypeGVCFs \
   -R ${genome_file} \
   -V ${gvcf_file} \
   -O ${pair_id_val}.vcf.gz"""
}