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
    genome
    reads
    main:
    def rglb = params.rglb ?: 'lib1'
    def rgpl = params.rgpl ?: 'ILLUMINA'
}