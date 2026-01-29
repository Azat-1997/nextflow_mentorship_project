include { BWA } from './modules/Indexing/Bwa.nf'
include { FAIDX } from './modules/Indexing/Faidx.nf'
include { PICARD } from './modules/Indexing/Picard.nf'
include { ALIGN } from './modules/Align/AlignReads.nf'
include { CONVERT2SORTED_BAM } from './modules/Samtools/Convert2SortedBam.nf'
include { INDEX_BAM } from './modules/Samtools/IndexBam.nf'
include { ADD_RG } from './modules/RG/AddRG.nf'
include { INDEX_RG_BAM } from './modules/RG/IndexRGBam.nf'
include { VARIANTCALLING } from './modules/GATK/VariantCalling.nf'
include { DBIMPORT } from './modules/GATK/DBImport.nf'
include { GENOTYPE } from './modules/GATK/GenotypeGVCFs.nf'
// Define input parameters

params.reads = "/reads/*_{1,2}.filt.fastq.gz"  // Input folder containing read files
params.ref_genome = Channel.fromPath('/genomes/mm9.fasta')

// Define the workflow
workflow {
    reads = Channel.fromFilePairs(params.reads, flat: true)
    genome_index =  BWA(params.ref_genome).bwa_index.collect()
    genome_faidx = FAIDX(params.ref_genome).faidx.collect()
    genome_dict = PICARD(params.ref_genome).dict.collect()
    aligned_reads = ALIGN(reads, params.ref_genome, genome_index, genome_faidx, genome_dict).sam
    bam = CONVERT2SORTED_BAM(aligned_reads).bam
    def rglb = params.rglb ?: 'lib1' // Delete after PREPROCESS implementation
    def rgpl = params.rgpl ?: 'ILLUMINA' // Delete after PREPROCESS implementation
    rg_bam = ADD_RG(bam, rglb, rgpl).rg_bam
    //rg_bai = INDEX_BAM(rg_bam).bai
    rg_bai = INDEX_RG_BAM(rg_bam).rg_bai
    vcf = VARIANTCALLING(params.ref_genome, genome_faidx, genome_dict, rg_bam, rg_bai).vcf
    database = DBIMPORT(vcf).database
    params.ref_genome.view()
    GENOTYPE(vcf, params.ref_genome, genome_faidx, genome_dict).genotype_gvcf.view()
}
