# Needed everytime
module load Nextflow/24.10.2
export APPTAINER_CACHEDIR=${VSC_SCRATCH}/.apptainer_cache
export APPTAINER_TMPDIR=${VSC_SCRATCH}/.apptainer_tmp

# Needed once
mkdir ${VSC_SCRATCH}/.apptainer_cache
mkdir ${VSC_SCRATCH}/.apptainer_tmp



# Steps for the plots

`module load Anaconda3/2024.06-1`

`conda activate r-plotting`

It wasn't working in the beginning because I needed to change the path in the R scripts to read data.csv.

