process CONVERT2SORTED_BAM {
    tag { meta.id }
    container 'broadinstitute/gatk'
    input:
    tuple val(meta), path(sam)
    output:
    tuple val(meta), path("${meta.id}.sorted.bam"), emit: bam
    script:
    """
    samtools view -@ ${task.cpus} -bS ${sam} \
        | samtools sort -@ ${task.cpus} -o ${meta.id}.sorted.bam
    """
}