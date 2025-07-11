#!/bin/bash -ue
apptainer run --app Rscript -e "install.packages(c('tidyverse', 'patchwork', 'lmerTest', 'Rmisc'), repos='http://cran.us.r-project.org')"
apptainer run --app Rscript /scratch/gent/491/vsc49179/nextflow-project/modules/r-base.3.4.4.simg plot_figures.R
