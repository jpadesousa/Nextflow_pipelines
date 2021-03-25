#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.bisulfite  = ''
params.single_end = false

process FASTQ_SCREEN {

	label 'fastqScreen'
	tag "$name" // Adds name to job submission instead of (1), (2) etc.
	
	input:
		tuple val(name), path(reads)
		val(outputdir)
		val(fastq_screen_args)
		val(verbose)

	output:
	  	//path "*png",  emit: png
	  	path "*html", emit: html
	  	path "*txt",  emit: report
		  
		publishDir "$outputdir/unaligned/qc", mode: "link", overwrite: true

	script:
		if (verbose){
			println ("[MODULE] FASTQ SCREEN ARGS: "+ fastq_screen_args)
		}

		if (params.single_end){
			// TODO: Add single-end parameter
		}
		else{
			// for paired-end files we only use Read 1 (as Read 2 tends to show the exact same thing)
			if (reads instanceof List) {
				reads = reads[0]
			}
		}

		"""
		module load fastq-screen
		fastq_screen $params.bisulfite $fastq_screen_args $reads
		"""
}
