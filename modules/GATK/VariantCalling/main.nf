process VARIANTCALLING {
    tag { meta.id }
    container 'broadinstitute/gatk'
    input:
    path genome  
    tuple val(index_meta), path(index) 
    tuple val(dict_meta), path(dict) 
    tuple val(meta), path(bam_file), path(bam_index) 
    output:
    tuple val(meta), path("${meta.id}.g.vcf.gz"), path("${meta.id}.g.vcf.gz.tbi"), emit: vcf
    script:
    """gatk --java-options "-Xmx4g" HaplotypeCaller  \
   -R ${genome} \
   -I ${bam_file} \
   -O '${meta.id}.g.vcf.gz' \
   -ERC GVCF """
}
