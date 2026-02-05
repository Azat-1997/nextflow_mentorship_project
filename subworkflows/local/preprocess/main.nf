include { BWA } from '../../../modules/Indexing/Bwa/main.nf'
include { FAIDX } from '../../../modules/Indexing/Faidx/main.nf'
include { PICARD } from '../../../modules/Indexing/Picard/main.nf'
include { ALIGN } from '../../../modules/Align/main.nf'
include { CONVERT2SORTED_BAM } from '../../../modules/Samtools/Convert2SortedBam/main.nf'
include { ADD_RG } from '../../../modules/RG/AddRG/main.nf'
include { INDEX_RG_BAM } from '../../../modules/RG/IndexRGBam/main.nf'

workflow PREPROCESS {
    take:
    ref_genome
    reads
    main:
    // make indexes for alignment and GATK
    bwa = BWA(ref_genome)
    faidx = FAIDX(ref_genome).faidx
    dict = PICARD(ref_genome).dict
    
    // make alignment 
    sam  = ALIGN(reads, ref_genome, bwa, faidx, dict).sam
    bam  = CONVERT2SORTED_BAM(sam)

    // add group for proper work of GATK
    def rglb = params.rglb ?: 'lib1'
    def rgpl = params.rgpl ?: 'ILLUMINA'
    rg_bam = ADD_RG(bam, rglb, rgpl).rg_bam

    // prepare output
    bam_pair = INDEX_RG_BAM(rg_bam).rg_bam_pair

    emit:
        bam_pair
        faidx
        dict

}