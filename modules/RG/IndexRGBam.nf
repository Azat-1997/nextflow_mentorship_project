process INDEX_RG_BAM {
    tag { pair_id_val }
    input:
        tuple val(pair_id_val), path(bam)
    output:
        tuple val(pair_id_val), path("${pair_id_val}.rg.bai"), emit: rg_bai
    script:
        """
        samtools index ${bam} ${pair_id_val}.rg.bai
        """
}