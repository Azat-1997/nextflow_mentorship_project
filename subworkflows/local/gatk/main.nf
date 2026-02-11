include { VARIANTCALLING } from '../../../modules/GATK/VariantCalling/main.nf'
include { DBIMPORT } from '../../../modules/GATK/DBImport/main.nf'
include { GENOTYPE } from '../../../modules/GATK/GenotypeGVCFs/main.nf'

workflow GATK {
    take:
    ref_genome
    faidx 
    dict 
    bam_pair

    main: 
    vcf = VARIANTCALLING(ref_genome, faidx, dict, bam_pair).vcf
    database = DBIMPORT(vcf)
    genotype_vcf = GENOTYPE(ref_genome, faidx, dict, vcf)

    emit:
    genotype_vcf
    database
}
