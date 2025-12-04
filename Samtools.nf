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

workflow {
    sam_files = Channel.of(['gatk-examples_example1_NA19913_ERR250967',
     'work/b1/8a3ef1b3fd1fcca179de9fce80160c/mm9_gatk-examples_example1_NA19913_ERR250967.sam'],
    ['examples_example1_NA19913_ERR250256',
    'work/dc/1bbd9181a51b739bc3bd90809a0441/mm9_gatk-examples_example1_NA19913_ERR250256.sam'])
    CONVERT2SORTED_BAM(sam_files)
}