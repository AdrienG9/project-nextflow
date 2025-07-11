# Nextflow Project – VIB/UGent Microcredential

This repository contains a modular Nextflow pipeline developed as part of the **VIB/UGent Reproducible Analysis Microcredential**.  
It performs data extraction, analysis, and visualization using containerized and reproducible tools.

---

## What the Pipeline Does

1. **Extract `.tar.gz` archive**
2. **Extract CSV column headers**
3. **Generate plots using R**
4. **Split CSV files by a column value (exp_index)**
5. **Recombine split files back into one**

---

## Modules Used

| Module         | Description                       | 
|----------------|-----------------------------------|
| `untar.nf`     | Extracts archive                  | 
| `columns.nf`   | Gets CSV column names             | 
| `plot.nf`      | Plots figures in R                | 
| `split.nf`     | Splits CSV by `exp_index`         | 
| `combine.nf`   | Recombines CSVs                   | 

---

## Key Features

- **Docker & Apptainer compatible**
- **Custom R script** with `ggplot2`, `lmerTest`, `patchwork`
- **Conda environment** used to build the container
- **No setup required** — just run and go
- **Outputs organized** under `modules/output/`

---

## Requirements Met
 
- ✅ ≥3 custom modules  
- ✅ Custom + external tools  
- ❌  No manual setup needed  
- ✅ GitHub hosted  
- ✅ Structured output  
- ✅ Multiple Nextflow operators used (`collect`, `flatMap`, `view`, etc.)

---

## ▶️ Run the Pipeline

```bash
module load Nextflow/24.10.2
export APPTAINER_CACHEDIR=${VSC_SCRATCH}/.apptainer_cache
export APPTAINER_TMPDIR=${VSC_SCRATCH}/.apptainer_tmp

nextflow run main.nf
```

# ❌  Automatic setup problems

Built the image of my environment used with conda:

`apptainer build r-plotting.sif r_plotting.def`

Succesfully:

```bash
apptainer exec r-plotting.sif Rscript --version
Rscript (R) version 4.3.0 (2023-04-21)
```

But unfortunately Rscript command is never found no matter the Script modification in plot.nf.
So for now, only works using conda.

# Additional steps to be able to run for the plot

Modify nextflow config to enable conda, then:

`module load Anaconda3/2024.06-1`

`conda activate r-plotting`





