include { BWA } from './Indexing.nf'
include { FAIDX } from './Indexing.nf'
include { PICARD } from './Indexing.nf'
include { ALIGN } from './AlignReads.nf'
include { CONVERT2SORTED_BAM } from './Samtools.nf'
include { INDEX_BAM } from './Samtools.nf'
include { VARIANTCALLING } from './VariantCalling.nf'
include { ADD_RG } from './AddRG.nf'
include { INDEX_RG_BAM } from './AddRG.nf'
// Define input parameters

params.reads = "./reads/*_{1,2}.filt.fastq.gz"  // Input folder containing read files
params.ref_genome = Channel.fromPath('./genomes/mm9.fasta')

// Define the workflow
workflow {
    reads = Channel.fromFilePairs(params.reads, flat: true)
    genome_index =  BWA(params.ref_genome).bwa_index.collect()
    genome_faidx = FAIDX(params.ref_genome).faidx.collect()
    genome_dict = PICARD(params.ref_genome).dict.collect()
    genome_dict.view()
    aligned_reads = ALIGN(reads, genome_index, genome_faidx, genome_dict).sam
    bam = CONVERT2SORTED_BAM(aligned_reads).bam

    def rglb = params.rglb ?: 'lib1'
    def rgpl = params.rgpl ?: 'ILLUMINA'
    rg_bam = ADD_RG(bam, rglb, rgpl).rg_bam
    rg_bai = INDEX_RG_BAM(rg_bam).rg_bai
    rg_bai.view()
    vcf = VARIANTCALLING(params.ref_genome, genome_faidx, genome_dict, rg_bam, rg_bai).vcf
    vcf.view()
}
