process VARIANTCALLING {
    tag { pair_id_val }
    input:
    path genome  
    path index 
    path dict 
    tuple val(pair_id_val), path(bam_index), path(bam_file) 
    output:
    tuple val(pair_id_val), path("${pair_id_val}.g.vcf.gz.tbi"), path("${pair_id_val}.g.vcf.gz"), emit: vcf
    script:
    """gatk --java-options "-Xmx4g" HaplotypeCaller  \
   -R ${genome} \
   -I ${bam_file} \
   -O '${pair_id_val}.g.vcf.gz' \
   -ERC GVCF """
}
