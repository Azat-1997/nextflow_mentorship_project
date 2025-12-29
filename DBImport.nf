params.container = 'broadinstitute/gatk' 
process DBIMPORT {
    container params.container
    tag { pair_id_val }
    input:
    tuple val(pair_id_val), path(gvcf_file), path(gvcf_index) 
    output:
    path pair_id_val, emit: database
    script:
    """gatk --java-options "-Xmx4g -Xms4g" GenomicsDBImport \
      -V ${gvcf_file} \
      --genomicsdb-workspace-path ${pair_id_val} \
      --intervals chrM"""
}
