# Estimating Progression of Alzheimer’s Disease with Extracellular Vesicle-Related Multi-Omics Risk Models

## Introduction
This repository provides the source code and raw datasets associated with the paper _Estimating Progression of Alzheimer’s Disease with Extracellular Vesicle-Related Multi-Omics Risk Models_.

Alzheimer's Disease (AD) is increasing in prevalence as the old age population increases in many countries. Ongoing research has difficulty in identifying root causes due to the heterogeneity of AD and complexities of interconnected pathways at various biological levels. Risk scores have greatly contributed to disease prognosis and biomarker discovery, but generally only consider generic risk factors.

We proposed an approach to constructing risk scores that takes advantage of extracellular vesicle (EV) and multi-omics data. Risk scores will be constructed for three types of omics data at different biological levels. EV-related genes localized in brain tissue will serve as a filter to find significant risk factors. The overall project workflow is depicted below.
![Architecture](https://github.com/user-attachments/assets/34cbaeaf-7046-4530-a244-ecbf04ad4221)

## Data

### Sources
Three risk models are trained on data from different modalities.
* __Transcriptomics__: gene expression data from [ADNI]().
* __Proteomics__: protein expression data from [UK Biobank]().
* __DNA Methylation__: DNA methylation data from [ADNI]().

Evaluation was performed of external data from Gene Expression Omnibus (GEO). Only transcriptomics data was evaluated due to data availability.
* __Transcriptomics__: gene expression data from [GSE5281]().

### Obtaining Data

Raw data from the above sources must undergo manual modifications prior to usage in the provided source code. Begin by placing all data files in the `./data` directory. Rename files to remove date prefix/suffix (*e.g.,* `ROSTER_22Jul2024.csv` → `ROSTER.csv`).

__ADNI__ data can be directly downloaded from the [Image and Data Archive (IDA)](https://ida.loni.usc.edu/) using the Analysis Ready Cohort (ARC) Builder.

Downloads:
* /Study Files/Enrollment/Roster.csv
* /Genetic Files/ADNI Gene Expression/Microarray Gene Expression Profile Data.csv
* /Genetic Files/DNA methylation profiling/Whole-genome DNA methylation profiling Data.idat

Search:
* /Subjects/Demographics/PTDEMOG
* /Assessments/Diagnosis/DXSUM

You must run `preprocess_methylation.R` to pre-process the DNA methylation data for use in the risk score. This R script will convert the raw values to beta values, convert loci annotations to gene symbols, aggregate gene symbols, and output multiple files into the `/data` folder.

__UK Biobank__ data can be accessed using the [Research Analysis Platform (RAP)](https://ukbiobank.dnanexus.com/) using the Dataset file.

Proteomics data
* Tab: `Data Preview`
* Display Entity: `Olink Instance 0`
* Filter: `Date G31 first reported = IS NOT NULL`
* Columns:
    * Genes from `/data/NDEV.csv`

Demographics data
* Tab: `Data Preview`
* Display Entity: `Participant`
* Filter: `N/A`
* Columns:
    * Sex
    * Year of birth
    * Age at recruitment

Survival data
* Tab: `Data Preview`
* Display Entity: `Participant`
* Filter: `N/A`
* Columns:
    * Date G30 first reported (alzheimer's disease)
    * Date G31 first reported (other degenerative diseases of nervous system, not elsewhere classified)
    * Date G32 first reported (other degenerative disorders of nervous system in diseases classified elsewhere)

If you have trouble downloading the data, try to separate each download to contain less than 30 columns.

__GEO__ data is retrieved using GEOquery in an R script. Running the script `GSE5281.R` will automatically retrieve the matrix file, convert the annotations to gene symbols, and output the file into the `/data` folder.

## Risk Model

A risk model is constructed at each of the three levels of biology: DNA methylation, transcriptomics, and proteomics.

Begin by installing required Python packages. [Conda](https://docs.anaconda.com/miniconda/) is recommended as a package management tool. The following instructions will apply to Conda.

1. Install [Miniconda](https://docs.anaconda.com/miniconda/miniconda-install/)
2. Create a new environment
    * You must be in the directory `/AD-Multi-Omics-EV-Risk-Model` that contains `requirements.txt`
    * If any packages fail to install, you can try to install the package manually using `pip install <package>`
```
$ conda create -n riskmodel --file requirements.txt python=3.11.4
```
3. Activate the Conda environment
```
$ conda activate riskmodel
```
4. Start the Jupyter Notebook server
```
$ jupyter notebook
```

The __baseline risk models__ using EV-related multi-omics data is constructed from 3 different Jupyter Notebooks.

* DNA Methylation: `risk_score_methylation.ipynb`
* Transcriptomics: `risk_score_transcriptomics.ipynb`
* Proteomics: `risk_score_proteomics.ipynb`

An additional __comparison risk model__ for transcriptomics data is built on all genes, rather than EV-related genes, in transcriptomics data.

* Transcriptomics (all genes): `risk_score_transcriptomics_comparison.ipynb`

## Evaluation

Evaluation is performed on the transcriptomics risk model using an external dataset [GSE5281](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE5281). Both baseline (EV-related genes) and comparison (all genes) risk models are evaluated.

* Transcriptomics (baseline): `eval_transcriptomics.ipynb`
* Transcriptomics (comparison): `eval_transcriptomics_comparison.ipynb`