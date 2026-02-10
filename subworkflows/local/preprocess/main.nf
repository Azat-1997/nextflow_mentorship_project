include { BWA_INDEX } from '../../../modules/Bwa/Index/main.nf'
include { FAIDX } from '../../../modules/Faidx/main.nf'
include { PICARD } from '../../../modules/Picard/main.nf'
include { BWA_ALIGN } from '../../../modules/Bwa/Align/main.nf'
include { CONVERT2SORTED_BAM } from '../../../modules/Samtools/Convert2SortedBam/main.nf'
include { ADD_RG } from '../../../modules/RG/AddRG/main.nf'
include { INDEX_RG_BAM } from '../../../modules/RG/IndexRGBam/main.nf'

workflow PREPROCESS {
    take:
    ref_genome
    reads
    main:
    // make indexes for alignment and GATK
    genome_path = new File(ref_genome)
    ref_genome_ch = tuple(genome_path.baseName, ref_genome)  
    bwa_index = BWA_INDEX(ref_genome_ch).bwa_index
    bwa_index.view()
    faidx = FAIDX(ref_genome_ch).faidx
    faidx.view()
    dict = PICARD(ref_genome_ch).dict
    dict.view()
    
    // make alignment 
    sam  = BWA_ALIGN(reads, ref_genome, bwa_index).sam
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