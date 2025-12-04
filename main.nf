include { BWA } from './Indexing.nf'
include { FAIDX } from './Indexing.nf'
include { PICARD } from './Indexing.nf'
include { ALIGN } from './AlignReads.nf'
include { CONVERT2SORTED_BAM } from './Samtools.nf'
// Define input parameters

params.reads = "./reads/*_{1,2}.filt.fastq.gz"  // Input folder containing read files
params.ref_genome = Channel.fromPath('./genomes/mm9.fasta')

// Define the workflow
workflow {
    reads = Channel.fromFilePairs(params.reads, flat: true)
    genome_index =  BWA(params.ref_genome).bwa_index.collect()
    genome_faidx = FAIDX(params.ref_genome).faidx.collect()
    genome_dict = PICARD(params.ref_genome).dict.collect()
    aligned_reads = ALIGN(reads, genome_index, genome_faidx, genome_dict).sam
    CONVERT2SORTED_BAM(aligned_reads).bam.view()
}
