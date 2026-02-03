process DBIMPORT {
    tag { pair_id_val }
    input:
    tuple val(pair_id_val), path(gvcf_index), path(gvcf_file) 
    output:
    path pair_id_val, emit: database
    script:
    """gatk --java-options "-Xmx4g -Xms4g" GenomicsDBImport \
      -V ${gvcf_file} \
      --genomicsdb-workspace-path ${pair_id_val} \
      --intervals chrM"""
}
