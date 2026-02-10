process VARIANTCALLING {
    tag { meta.id }
    container 'broadinstitute/gatk'
    input:
    path genome  
    tuple val(index_meta), path(index) 
    tuple val(dict_meta), path(dict) 
    tuple val(meta), path(bam_index), path(bam_file) 
    output:
    tuple val(meta), path("${meta.id}.g.vcf.gz.tbi"), path("${meta.id}.g.vcf.gz"), emit: vcf
    script:
    """gatk --java-options "-Xmx4g" HaplotypeCaller  \
   -R ${genome} \
   -I ${bam_file} \
   -O '${meta.id}.g.vcf.gz' \
   -ERC GVCF """
}
