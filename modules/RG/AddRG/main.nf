process ADD_RG {
  tag { pair_id_val }
  container 'broadinstitute/gatk'
  input:
    tuple val(pair_id_val), path(bam)
    val  rglb
    val  rgpl
  output:
    tuple val(pair_id_val), path("${pair_id_val}.rg.bam"), emit: rg_bam
  script:
    def rgid = pair_id_val
    def rgpu = "${pair_id_val}.PU"
    def rgsm = pair_id_val
    """
  gatk AddOrReplaceReadGroups \
      -I "${bam}" \
      -O "${pair_id_val}.rg.bam" \
      -RGID "${rgid}" \
      -RGLB "${rglb}" \
      -RGPL "${rgpl}" \
      -RGPU "${rgpu}" \
      -RGSM "${rgsm}"
  """
}



