#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.data   = "output/extracted_results/extracted/*"
params.column = "exp_index"
params.outdir = "output/split"

process SplitCsvPure {

    tag "$split_name"

    publishDir "${params.outdir}", mode: 'copy'

    input:
    tuple val(split_name), val(header), val(lines)

    output:
    path "${split_name}.csv", emit: splits

    script:
    """
    echo "${header}" > ${split_name}.csv
    for line in ${lines.join(' ')}; do echo "\$line"; done >> ${split_name}.csv
    """
}

/*
workflow {

    Channel
        .fromPath(params.data, checkIfExists: true)
        .map { file ->
            def lines = file.text.readLines()
            def header = lines[0]
            def data = lines[1..-1]

            def headerCols = header.split(",").collect { it.replaceAll('"', '').trim() }
            def colIndex = headerCols.findIndexOf { it == params.column }

            if (colIndex == -1) {
                exit 1, "❌ Column '${params.column}' not found in header!"
            }

            // Group data rows by column value
            def grouped = data.groupBy { row ->
                def fields = row.split(",")
                def key = fields[colIndex].replaceAll('"', '').trim()
                return key
            }

            // Convert to channel items: emit each tuple separately
            return grouped.collect { key, rows ->
                tuple("${params.column}_${key}", header, rows)
            }
        }
        .flatMap { it } // Use flatMap instead of flatten to properly emit each tuple
        .set { split_ch }

    SplitCsvPure(split_ch)

    SplitCsvPure.out.splits.view { "✅ Wrote: $it" }
}
*/