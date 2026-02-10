process DBIMPORT {
    tag { meta.id }
    container 'broadinstitute/gatk'
    input:
    tuple val(meta), path(gvcf_index), path(gvcf_file) 
    output:
    tuple val(meta), path("${meta.id}"), emit: database
    script:
    """gatk --java-options "-Xmx4g -Xms4g" GenomicsDBImport \
      -V ${gvcf_file} \
      --genomicsdb-workspace-path ${meta.id} \
      --intervals chrM"""
}
