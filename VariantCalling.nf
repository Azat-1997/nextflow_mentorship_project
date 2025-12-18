genome = Channel.fromPath('resources_broad_hg38_v0_Homo_sapiens_assembly38.fasta')
genome_index = Channel.fromPath('resources_broad_hg38_v0_Homo_sapiens_assembly38.fasta.fai')
genome_dict = Channel.fromPath('resources_broad_hg38_v0_Homo_sapiens_assembly38.dict')
bam_file = Channel.of(['NA12878_20k_hg38_NA12878', new File("./wgs_bam_NA12878_20k_hg38_NA12878.bam").absolutePath])
bam_index = Channel.of(['NA12878_20k_hg38_NA12878', new File("./wgs_bam_NA12878_20k_hg38_NA12878.bai").absolutePath])
process VARIANTCALLING {
    container 'broadinstitute/gatk'
    tag { pair_id_val }
    input:
    path genome  
    path index 
    path dict 
    tuple val(pair_id_val), path(bam_file)
    tuple val(pair_id_val), path(bam_index) 
    output:
    tuple path("${pair_id_val}.g.vcf.gz"), path("${pair_id_val}.g.vcf.gz.tbi"), emit: vcf
    script:
    """gatk --java-options "-Xmx4g" HaplotypeCaller  \
   -R ${genome} \
   -I ${bam_file} \
   -O '${pair_id_val}.g.vcf.gz' \
   -ERC GVCF """
}

workflow {
    VARIANTCALLING(genome, genome_index, genome_dict, bam_file, bam_index);
 
}