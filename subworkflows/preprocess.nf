include { BWA } from '../modules/Indexing/Bwa.nf'
include { FAIDX } from '../modules/Indexing/Faidx.nf'
include { PICARD } from '../modules/Indexing/Picard.nf'
include { ALIGN } from '../modules/Align/AlignReads.nf'
include { CONVERT2SORTED_BAM } from '../modules/Samtools/Convert2SortedBam.nf'
include { INDEX_BAM } from '../modules/Samtools/IndexBam.nf'
include { ADD_RG } from '../modules/RG/AddRG.nf'
include { INDEX_RG_BAM } from '../modules/RG/IndexRGBam.nf'

workflow PREPROCESS {
    take:
    ref_genome
    reads
    main:
    // make indexes for alignment and GATK
    BWA(ref_genome)
    FAIDX(ref_genome)
    PICARD(ref_genome)
    
    // make alignment 
    ALIGN(reads, ref_genome, BWA.out.bwa_index, FAIDX.out.faidx, PICARD.out.dict)
    CONVERT2SORTED_BAM(ALIGN.out.sam)

    // add group for proper work of GATK
    def rglb = params.rglb ?: 'lib1'
    def rgpl = params.rgpl ?: 'ILLUMINA'
    ADD_RG(CONVERT2SORTED_BAM.out.bam, rglb, rgpl)
    INDEX_RG_BAM(ADD_RG.out.rg_bam)

    // prepare output
    bam_pair = INDEX_RG_BAM.out.rg_bam_pair
    faidx = FAIDX.out.faidx
    dict = PICARD.out.dict

    emit:
        bam_pair
        faidx
        dict

}