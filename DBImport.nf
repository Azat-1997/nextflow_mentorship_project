gvcf_file = Channel.fromPath('Haplotyper/Test-ready.g.vcf.gz')
gvcf_index = Channel.fromPath('Haplotyper/Test-ready.g.vcf.gz.tbi')
params.output_dir = 'output_dir'
process DBIMPORT {
    container 'broadinstitute/gatk'
    publishDir 'DBImport'
    input:
    path gvcf_file
    path gvcf_index 
    output:
    path params.output_dir
    script:
    """gatk --java-options "-Xmx4g -Xms4g" GenomicsDBImport \
      -V ${gvcf_file} \
      --genomicsdb-workspace-path ${params.output_dir} \
      --intervals chrM"""
}

workflow {
    DBIMPORT(gvcf_file, gvcf_index);
 
}