process DBIMPORT {
    tag { meta.id }
    container 'broadinstitute/gatk'
    input:
    tuple val(meta), path(gvcf_file), path(gvcf_index) 
    output:
    tuple val(meta), path("${meta.id}"), emit: database
    script:
    """gatk --java-options "-Xmx4g -Xms4g" GenomicsDBImport \
      -V ${gvcf_file} \
      --genomicsdb-workspace-path ${meta.id} \
      --intervals ${params.chr}"""
}
