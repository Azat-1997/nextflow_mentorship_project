process SAMTOOLS_SORT_BAM {
    tag { meta.id }
    container 'broadinstitute/gatk'
    input:
    tuple val(meta), path(bam)
    output:
    tuple val(meta), path("${meta.id}.sorted.bam"), emit: bam_sorted
    script:
    """
    samtools sort -@ ${task.cpus} ${bam} -o ${meta.id}.sorted.bam
    """
}