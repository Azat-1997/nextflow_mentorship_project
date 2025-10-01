genome = Channel.fromPath('resources_broad_hg38_v0_Homo_sapiens_assembly38.fasta')
genome_index = Channel.fromPath('resources_broad_hg38_v0_Homo_sapiens_assembly38.fasta.fai')
genome_dict = Channel.fromPath('resources_broad_hg38_v0_Homo_sapiens_assembly38.dict')
bam_file = Channel.fromPath('wgs_bam_NA12878_20k_hg38_NA12878.bam')
bam_index = Channel.fromPath('wgs_bam_NA12878_20k_hg38_NA12878.bai')
params.output_file_name = 'output'
process VARIANTCALLING {
    container 'broadinstitute/gatk'
    publishDir 'Haplotyper', pattern: "*.g.vcf.gz*"
    input:
    path genome
    path index 
    path dict
    path bam_file
    path bam_index 
    output:
    path "${params.output_file_name}.g.vcf.gz"
    path "${params.output_file_name}.g.vcf.gz.tbi"
    script:
    """gatk --java-options "-Xmx4g" HaplotypeCaller  \
   -R ${genome} \
   -I ${bam_file} \
   -O '${params.output_file_name}.g.vcf.gz' \
   -ERC GVCF"""
}

workflow {
    VARIANTCALLING(genome, genome_index, genome_dict, bam_file, bam_index);
 
}