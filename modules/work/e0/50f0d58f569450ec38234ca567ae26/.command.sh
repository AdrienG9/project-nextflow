#!/bin/bash -ue
apptainer run --app Rscript /scratch/gent/491/vsc49179/nextflow-project/modules/envs/r-pipeline.sif plot_figures.R
