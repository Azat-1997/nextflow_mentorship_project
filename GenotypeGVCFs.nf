genome_file = Channel.fromPath('resources_broad_hg38_v0_Homo_sapiens_assembly38.fasta')
genome_index = Channel.fromPath('resources_broad_hg38_v0_Homo_sapiens_assembly38.fasta.fai')
genome_dict = Channel.fromPath('resources_broad_hg38_v0_Homo_sapiens_assembly38.dict')
gvcf_file = Channel.fromPath('Haplotyper/NA12878.g.vcf.gz')
gvcf_index = Channel.fromPath('Haplotyper/NA12878.g.vcf.gz.tbi')
params.output_file_name = 'output_genotype'
process GENOTYPE {
    container 'broadinstitute/gatk'
    publishDir 'Genotype'
    input:
    path gvcf_file
    path gvcf_index
    path genome_file
    path genome_index
    path genome_dict
    output:
    path "${params.output_file_name}.vcf.gz"
    path "${params.output_file_name}.vcf.gz.tbi"
    script:
    """gatk --java-options "-Xmx4g" GenotypeGVCFs \
   -R ${genome_file} \
   -V ${gvcf_file} \
   -O ${params.output_file_name}.vcf.gz"""
}

workflow {
    GENOTYPE(gvcf_file, gvcf_index, genome_file, genome_index, genome_dict);
 
}