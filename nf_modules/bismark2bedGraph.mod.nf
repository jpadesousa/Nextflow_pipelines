#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// parameters passed in by specialised pipelines
params.dirty_harry = false

process BISMARK2BEDGRAPH {
	
	label 'bismark2bedGraph'
	tag "$name" // Adds name to job submission instead of (1), (2) etc.
			
    input:
	    tuple val(name), path(reads)
		val (outputdir)
		val (bismark2bedGraph_args)
		val (verbose)

	output:
	    path "*cov.gz",        emit: coverage
		path "*bedGraph.gz",   emit: bedGraph

		publishDir "$outputdir/aligned/methylation_coverage", mode: "link", overwrite: true, pattern: "*cov.gz"
		publishDir "$outputdir/aligned/methylation_bedgraph", mode: "link", overwrite: true, pattern: "*bedGraph.gz"

    script:

		if (verbose){
			println ("[MODULE] BISMARK2BEDGRAPH ARGS: " + bismark2bedGraph_args)
		}

		// Options we add are
		bismark2bedGraph_options = bismark2bedGraph_args

		if (params.dirty_harry){
			output_name = name + "_DH.bedGraph.gz"  // Dirty Harry
		} 
		else{
			output_name = name + ".bedGraph.gz"
		}
		// println ("Output name: $output_name")
		// println ("Input names: $reads")
		
		all_reads = reads

		"""
		module load bismark
		bismark2bedGraph --buffer 15G -o $output_name $bismark2bedGraph_options $all_reads
		"""
}