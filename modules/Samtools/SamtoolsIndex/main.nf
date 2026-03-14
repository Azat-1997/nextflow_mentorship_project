process SAMTOOLS_INDEX {
    tag { meta.id }
    container 'broadinstitute/gatk'
    input:
        tuple val(meta), path(bam)
    output:
        tuple val(meta), path("${meta.id}.bam"), path("${meta.id}.bai"), emit: bam_pair
    script:
        """
        samtools index ${bam} ${meta.id}.bai
        """
}