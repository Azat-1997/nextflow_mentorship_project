process INDEX_RG_BAM {
    tag { meta.id }
    container 'broadinstitute/gatk'
    input:
        tuple val(meta), path(bam)
    output:
        tuple val(meta), path("${meta.id}.rg.bai"), path("${meta.id}.rg.bam"), emit: rg_bam_pair
    script:
        """
        samtools index ${bam} ${meta.id}.rg.bai
        """
}