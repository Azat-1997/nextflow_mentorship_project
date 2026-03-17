process VARIANTCALLING {
    tag { meta.id }
    container 'broadinstitute/gatk'
    input:
    tuple val(genome_meta), path(genome), path(fai), path(dict)
    tuple val(meta), path(bam_file), path(bam_index) 
    val(erc)
    output:
    tuple val(meta), path("${meta.id}.g.vcf.gz"), path("${meta.id}.g.vcf.gz.tbi"), emit: vcf
    script:
    """gatk --java-options "-Xmx4g" HaplotypeCaller  \
   -R ${genome} \
   -I ${bam_file} \
   -O '${meta.id}.g.vcf.gz' \
   -ERC ${erc} """
}
