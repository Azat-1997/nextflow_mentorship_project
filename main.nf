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
        genome_tuple = PREPROCESS.out.genome_tuple
        GATK(genome_tuple, bam_pair,  params.erc, params.chr)
    } else if (params.bam && params.faidx && params.dict) {
        println "Looking for aligned data and indexes"
        bam = Channel.fromPath(params.bam)
        bai = Channel.fromPath(params.bai)
        bam_pair = bam.map({file -> ['id': file.baseName]}).merge(bam).merge(bai)
        // faidx and dict should be value channels!!
        genome_tuple = tuple(['id': genome_path.baseName], params.ref_genome,
         params.faidx, params.dict)
        gatk = GATK(genome_tuple, bam_pair, params.erc, params.chr)
    } else {
        println "Data are absence: specify Reads or Bam files"
    }

}