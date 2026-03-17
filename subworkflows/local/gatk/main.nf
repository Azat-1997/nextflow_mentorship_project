include { VARIANTCALLING } from '../../../modules/GATK/VariantCalling/main.nf'
include { DBIMPORT } from '../../../modules/GATK/DBImport/main.nf'
include { GENOTYPE } from '../../../modules/GATK/GenotypeGVCFs/main.nf'

workflow GATK {
    take:
    genome_tuple
    bam_pair
    erc
    interval

    main: 
    vcf = VARIANTCALLING(genome_tuple, bam_pair, erc).vcf
    database = DBIMPORT(vcf, interval)
    genotype_vcf = GENOTYPE(genome_tuple, vcf)

    emit:
    genotype_vcf
    database
}
