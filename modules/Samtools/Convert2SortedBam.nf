process CONVERT2SORTED_BAM {
    tag { pair_id_val }
    input:
    tuple val(pair_id_val), path(sam)
    output:
    tuple val(pair_id_val), path("${pair_id_val}.sorted.bam"), emit: bam
    script:
    """
    samtools view -@ ${task.cpus} -bS ${sam} \
        | samtools sort -@ ${task.cpus} -o ${pair_id_val}.sorted.bam
    """
}