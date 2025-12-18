params.container = "broadinstitute/gatk"
params.task_cpus = 2

process CONVERT2SORTED_BAM {
    container params.container
    tag { pair_id_val }
    input:
    tuple val(pair_id_val), path(sam)
    output:
    tuple val(pair_id_val), path("${pair_id_val}.sorted.bam"), emit: bam
    script:
    """
    samtools view -@ ${params.task_cpus} -bS ${sam} \
        | samtools sort -@ ${params.task_cpus} -o ${pair_id_val}.sorted.bam
    """
}

process INDEX_BAM {
    container params.container
    tag { pair_id_val }
    input:
    tuple val(pair_id_val), path(bam)
    output:
    tuple val(pair_id_val), path("${pair_id_val}.bai"), emit: bai
    script:
    """
    samtools index ${bam} ${pair_id_val}.bai
    """
}

