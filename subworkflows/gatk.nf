include { VARIANTCALLING } from '../modules/GATK/VariantCalling.nf'
include { DBIMPORT } from '../modules/GATK/DBImport.nf'
include { GENOTYPE } from '../modules/GATK/GenotypeGVCFs.nf'

workflow GATK {
    take:
    ref_genome
    faidx 
    dict 
    bam_pair

    main: 
    VARIANTCALLING(ref_genome, faidx, dict, bam_pair)
    DBIMPORT(VARIANTCALLING.out.vcf)
    raw_vcf = GENOTYPE(ref_genome, faidx, dict, VARIANTCALLING.out.vcf)

    emit:
    raw_vcf
}
