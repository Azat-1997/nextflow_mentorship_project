include { PREPROCESS } from './subworkflows/preprocess.nf'

params.reads = "${PWD}/reads/*_{1,2}.filt.fastq.gz"  // Input folder containing read files
params.ref_genome = Channel.fromPath("${PWD}/genomes/mm9.fasta")


workflow {
reads = Channel.fromFilePairs(params.reads, flat: true)
PREPROCESS(params.ref_genome, reads)

}