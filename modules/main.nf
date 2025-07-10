#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

// Include processes
include { EXTRACT_ARCHIVE; VERIFY_EXTRACTION } from './untar.nf'
include { Extract_columns }                    from './columns.nf'
include { GenerateFigures }                    from './plot.nf'
include { SplitCsvPure }                       from './split.nf'
include { RecombineCsv }                       from './combine.nf'

// Inputs
params.input_archive = "results/results.tar.gz"
params.column        = "exp_index"
params.helper        = "script/helper.R"
params.rscript       = "script/plot_figures.R"

// Module-defined paths — don't override
params.extracted_dir = "output/extracted_results/extracted/*"
params.split_dir     = "output/split/*.csv"

workflow {

    // Step 1: Extract archive
    archive_ch = Channel.fromPath(params.input_archive, checkIfExists: true)
    EXTRACT_ARCHIVE(archive_ch)

    // Step 2: Verify archive contents
    VERIFY_EXTRACTION(
        EXTRACT_ARCHIVE.out.file_list,
        EXTRACT_ARCHIVE.out.extracted_files.collect()
    )

    // Step 3: Extract column headers
    EXTRACT_ARCHIVE.out.extracted_files.collect().set { csv_files }

    Extract_columns(csv_files)
    Extract_columns.out.headers_nf.view { "📋 Headers file created: $it" }

    // Step 4: Generate plots
    Channel
        .fromPath(params.helper, checkIfExists: true)
        .set { helper_ch }

    Channel
        .fromPath(params.rscript, checkIfExists: true)
        .set { r_ch }

    GenerateFigures(csv_files, helper_ch, r_ch)
    GenerateFigures.out.plots.view { "📊 Plot created: $it" }

    // Step 5: Split CSV(s)
    EXTRACT_ARCHIVE.out.extracted_files
        .flatMap { file ->
            def lines = file.text.readLines()
            def header = lines[0]
            def data = lines[1..-1]
            def headerCols = header.split(",").collect { it.replaceAll('"', '').trim() }
            def colIndex = headerCols.findIndexOf { it == params.column }

            if (colIndex == -1) {
                error "❌ Column '${params.column}' not found in file ${file.name}!"
            }

            def grouped = data.groupBy { row -> 
                row.split(",")[colIndex].replaceAll('"', '').trim()
            }

            grouped.collect { key, rows -> 
                tuple("${params.column}_${key}", header, rows)
            }
        }
        .set { split_ch }

    SplitCsvPure(split_ch)

    // Step 6: Recombine - CORRECTED VERSION
    // Use the output channel from SplitCsvPure instead of reading from filesystem
    SplitCsvPure.out.splits.collect().set { files_ch }

    RecombineCsv(files_ch)
    RecombineCsv.out.combined.view { "🔁 Recombined file: $it" }
}