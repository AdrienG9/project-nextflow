#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.input_csv = "output/extracted_results/extracted/*"
params.outdir = "output/csv_columns"

process Extract_columns {

    container 'rocker_r-base.sif'

    publishDir "${params.outdir}", mode: 'copy'

    input:
    path input_csv

    output:
    path "headers.txt", emit: headers_nf

    script:
    """
    head -n 1 ${input_csv} | tr ',' '\\n' > headers.txt
    """
}

/*
workflow {

    Channel
        .fromPath(params.input_csv, checkIfExists: true)
        .set { csv_files }

    Extract_columns(csv_files)

    Extract_columns.out.headers_nf.view { "Headers file created: $it" }
}
*/
