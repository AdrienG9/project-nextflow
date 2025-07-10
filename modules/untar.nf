#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.input_archive = "results/results.tar.gz"
params.outdir = "output/extracted_results"

process EXTRACT_ARCHIVE {
    container 'rocker_r-base.sif'
    
    publishDir "${params.outdir}/", mode: 'copy'
    
    input:
    path archive
    
    output:
    path "extracted/*", emit: extracted_files
    path "file_list.txt", emit: file_list
    
    script:
    """
    # Create extraction directory
    mkdir -p extracted
    
    # Extract the archive
    tar -xzf ${archive} -C extracted
    
    # Create a list of extracted files
    find extracted -type f > file_list.txt
    
    echo "Extraction completed. Files extracted to: extracted/"
    echo "Number of files extracted: \$(find extracted -type f | wc -l)"
    """
}

process VERIFY_EXTRACTION {
    container 'rocker_r-base.sif'
    
    publishDir "${params.outdir}/verification/", mode: 'copy'
    
    input:
    path file_list
    path extracted_files
    
    output:
    path "extraction_report.txt", emit: report
    
    script:
    """
    echo "=== EXTRACTION VERIFICATION REPORT ===" > extraction_report.txt
    echo "Extraction completed at: \$(date)" >> extraction_report.txt
    echo "" >> extraction_report.txt
    
    echo "Files extracted:" >> extraction_report.txt
    cat ${file_list} >> extraction_report.txt
    echo "" >> extraction_report.txt
    
    echo "Total number of files: \$(cat ${file_list} | wc -l)" >> extraction_report.txt
    echo "Total size of extracted files: \$(du -sh extracted 2>/dev/null | cut -f1 || echo 'N/A')" >> extraction_report.txt
    
    echo "" >> extraction_report.txt
    echo "File types found:" >> extraction_report.txt
    find extracted -type f -name "*.*" | sed 's/.*\\.//' | sort | uniq -c | sort -nr >> extraction_report.txt
    """
}

/*
workflow {
    // Create channel from the input archive
    archive_ch = Channel.fromPath(params.input_archive, checkIfExists: true)
    
    // Extract the archive
    EXTRACT_ARCHIVE(archive_ch)
    
    // Verify the extraction
    VERIFY_EXTRACTION(
        EXTRACT_ARCHIVE.out.file_list,
        EXTRACT_ARCHIVE.out.extracted_files.collect()
    )
    
    // Display results
    EXTRACT_ARCHIVE.out.file_list.view { file -> 
        "Extraction completed. File list: ${file}" 
    }
    
    VERIFY_EXTRACTION.out.report.view { report -> 
        "Verification report created: ${report}" 
    }
}
*/