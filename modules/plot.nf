#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.data = "output/extracted_results/extracted/*"
params.helper = "script/helper.R"
params.rscript = "script/plot_figures.R"
params.plot_dir = "output/plots"

process GenerateFigures {
    //container 'docker://rocker/r-base:4.3.2'
    //container '/scratch/gent/491/vsc49179/nextflow-project/modules/envs/r-plotting.sif'
    conda "envs/r_plotting.yml" 


    publishDir "${params.plot_dir}", mode: 'copy'

    input:
    path data_csv
    path helper_script
    path r_script

    output:
    path "*.pdf", emit: plots

    script:
    """
    Rscript ${r_script}
    """
}

/*
workflow {

    Channel
        .fromPath(params.data, checkIfExists: true)
        .set { data_ch }

    Channel
        .fromPath(params.helper, checkIfExists: true)
        .set { helper_ch }

    Channel
        .fromPath(params.rscript, checkIfExists: true)
        .set { r_ch }

    GenerateFigures(data_ch, helper_ch, r_ch)

    GenerateFigures.out.plots.view { "📊 Plot created: $it" }
}
*/