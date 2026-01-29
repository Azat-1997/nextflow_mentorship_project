genome_file = Channel.fromPath('resources_broad_hg38_v0_Homo_sapiens_assembly38.fasta')
genome_index = Channel.fromPath('resources_broad_hg38_v0_Homo_sapiens_assembly38.fasta.fai')
genome_dict = Channel.fromPath('resources_broad_hg38_v0_Homo_sapiens_assembly38.dict')
gvcf_file = Channel.fromPath('Genotype/NA12878_genotype.vcf.gz')
gvcf_index = Channel.fromPath('Genotype/NA12878_genotype.vcf.gz.tbi')
gvcf_train_set = Channel.fromPath('1000G_omni2.5.hg38.sites.vcf.gz')
gvcf_train_index = Channel.fromPath('1000G_omni2.5.hg38.sites.vcf.gz.tbi')
gvcf_train_set2 = Channel.fromPath('resources_broad_hg38_v0_1000G_phase1.snps.high_confidence.hg38.vcf.gz')
gvcf_train_index2 = Channel.fromPath('resources_broad_hg38_v0_1000G_phase1.snps.high_confidence.hg38.vcf.gz.tbi')

params.output_file_name = 'output'
process RECALIBRATION {
    container 'broadinstitute/gatk'
    publishDir 'VariantRecalibration'
    input:
    path gvcf_file
    path gvcf_index
    path gvcf_train_set
    path gvcf_train_index
    path gvcf_train_set2
    path gvcf_train_index2
    path genome_file
    path genome_index
    path genome_dict
    output:
    path "${params.output_file_name}.recal"
    path "${params.output_file_name}.tranches"
    script:
    def gvcf_train_set_args2 = gvcf_train_set2 ? "hapmap,known=false,training=true,truth=false,prior=12.0:" + gvcf_train_set2.collect { it.toString() }.join(' ') : ""
    def gvcf_train_set_args = gvcf_train_set ? "omni,known=false,training=true,truth=false,prior=12.0:" + gvcf_train_set.collect { it.toString() }.join(' ') : ""
    """gatk VariantRecalibrator \
   -R ${genome_file} \
   -V ${gvcf_file} \
   --resource ${gvcf_train_set_args2} \
   -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR \
   -mode SNP \
   -O ${params.output_file_name}.recal \
   --tranches-file ${params.output_file_name}.tranches """
}

workflow {
    RECALIBRATION(gvcf_file, gvcf_index, gvcf_train_set, gvcf_train_index,
     gvcf_train_set2, gvcf_train_index2,
     genome_file, genome_index, genome_dict);
 
}