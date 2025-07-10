#!/usr/bin/env nextflow
params.input_files = "../data/*"

process CREATE_ARCHIVE {

    publishDir "results/", mode: 'copy'

    input:
    path input_files
    
    output:
    path "results.tar.gz"
    
    script:
    """
    tar -czf results.tar.gz ${input_files}
    """
}


workflow {
    // Create channel from parameter
    input_ch = Channel.fromPath(params.input_files)
                      .view { csv -> "Before splitCsv : $csv"}
    
    // Collect all files into a single list for archiving
    collected_files = input_ch.collect()
    
    // Pass to process
    CREATE_ARCHIVE(collected_files)
}