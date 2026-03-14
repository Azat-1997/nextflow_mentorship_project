process ADD_RG {
  tag { meta.id }
  container 'broadinstitute/gatk'
  input:
    tuple val(meta), path(bam)
    val  rglb
    val  rgpl
  output:
    tuple val(meta), path("${meta.id}.bam"), emit: rg_bam
  script:
    def rgid = meta.id
    def rgpu = "${meta.id}.PU"
    def rgsm = meta.id
    """
  gatk AddOrReplaceReadGroups \
      -I "${bam}" \
      -O "${meta.id}.bam" \
      -RGID "${rgid}" \
      -RGLB "${rglb}" \
      -RGPL "${rgpl}" \
      -RGPU "${rgpu}" \
      -RGSM "${rgsm}"
  """
}



