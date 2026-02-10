include { PREPROCESS } from './subworkflows/local/preprocess/main.nf'
include { GATK } from './subworkflows/local/gatk/main.nf'

workflow {
// Input folder containing read files
genome_path = new File(params.ref_genome)
ref_genome_ch = Channel.value(tuple(['id': genome_path.baseName], params.ref_genome))
    
if (params.reads) {
        reads = Channel.fromFilePairs(params.reads, flat: false).map({it -> [['id':it[0]]] + it[1]})
        PREPROCESS(ref_genome_ch, reads)
        bam_pair = PREPROCESS.out.bam_pair
        faidx = PREPROCESS.out.faidx
        dict = PREPROCESS.out.dict
        GATK(params.ref_genome, faidx, dict, bam_pair).genotype_vcf.view({"GENOTYPE VCF: ${it}"})
    } else if (params.bam && params.faidx && params.dict) {
        println "Looking for aligned data and indexes"
        bam_pair = Channel.fromFilePairs(params.bam, flat: true)
        faidx = Channel.fromPath(params.faidx).first()
        dict = Channel.fromPath(params.dict).first()
        // faidx and dict should be value channels!!
        gatk = GATK(params.ref_genome, faidx, dict, bam_pair)
        gatk.genotype_vcf.view({"GENOTYPE VCF: ${it}"})
        gatk.database.view({"DATABASE: ${it}"})
    } else {
        println "Data are absence: specify Reads or Bam files"
    }

}