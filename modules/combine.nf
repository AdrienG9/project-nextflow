#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.split_dir = "output/split"
params.outfile   = "data.csv"
params.outdir    = "output/recombined"

process RecombineCsv {

    tag "recombine"

    publishDir "${params.outdir}", mode: 'copy'

    input:
    path csv_files

    output:
    path "${params.outfile}", emit: combined

    script:
    """
    # Extract header from the first file
    head -n 1 \$(ls ${csv_files} | head -n 1) > ${params.outfile}

    # Append all rows, skipping headers
    for f in ${csv_files}; do
      tail -n +2 "\$f"
    done | sort -t, -k1,1V -k2,2n >> ${params.outfile}
    """
}

/*
workflow {

    Channel
        .fromPath("${params.split_dir}/*.csv", checkIfExists: true)
        .collect()
        .set { files_ch }

    RecombineCsv(files_ch)

    RecombineCsv.out.combined.view { "✅ Recombined file: $it" }
}
*/
