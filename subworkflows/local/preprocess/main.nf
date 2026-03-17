include { BWA_INDEX } from '../../../modules/Bwa/Index/main.nf'
include { FAIDX } from '../../../modules/Faidx/main.nf'
include { PICARD } from '../../../modules/Picard/main.nf'
include { BWA_ALIGN } from '../../../modules/Bwa/Align/main.nf'
include { SAMTOOLS_CONVERT2BAM } from '../../../modules/Samtools/SamtoolsConvert2Bam/main.nf'
include { SAMTOOLS_SORT_BAM } from '../../../modules/Samtools/SamtoolsSortBam/main.nf'
include { SAMTOOLS_INDEX } from '../../../modules/Samtools/SamtoolsIndex/main.nf'
include { ADD_RG } from '../../../modules/GATK/AddRG/main.nf'

workflow PREPROCESS {
    take:
    ref_genome
    reads
    main:
    // make indexes for alignment and GATK
    bwa_index = BWA_INDEX(ref_genome).bwa_index
    faidx = FAIDX(ref_genome).faidx
    dict = PICARD(ref_genome).dict
    
    // make alignment 
    sam  = BWA_ALIGN(reads, ref_genome, bwa_index).sam
    bam = SAMTOOLS_CONVERT2BAM(sam)
    bam_sorted = SAMTOOLS_SORT_BAM(bam)
    // add group for proper work of GATK
    def rglb = params.rglb ?: 'lib1'
    def rgpl = params.rgpl ?: 'ILLUMINA'
    rg_bam = ADD_RG(bam_sorted, rglb, rgpl).rg_bam

    // prepare output
    bam_pair = SAMTOOLS_INDEX(rg_bam).bam_pair

    emit:
        bam_pair
        genome_tuple = ref_genome | join(faidx) | join(dict) | first

}