process INDEX_RG_BAM {
    tag { pair_id_val }
    input:
        tuple val(pair_id_val), path(bam)
    output:
        tuple val(pair_id_val), path("${pair_id_val}.rg.bai"), path("${pair_id_val}.rg.bam"), emit: rg_bam_pair
    script:
        """
        samtools index ${bam} ${pair_id_val}.rg.bai
        """
}