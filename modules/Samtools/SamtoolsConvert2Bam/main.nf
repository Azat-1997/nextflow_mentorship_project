process SAMTOOLS_CONVERT2BAM {
    tag { meta.id }
    container 'broadinstitute/gatk'
    input:
    tuple val(meta), path(sam)
    output:
    tuple val(meta), path("${meta.id}.bam"), emit: bam
    script:
    """
    samtools view -@ ${task.cpus} -bS ${sam} > ${meta.id}.bam
    """
}