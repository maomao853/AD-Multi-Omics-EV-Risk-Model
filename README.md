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

ADNI data can be directly downloaded from the [Image and Data Archive (IDA)]().
* /Download/Genetic Data/ADNI Gene Expression
* /Download/Genetic Data/DNA methylation profiling
* /Download/Study Data/Subject Characteristics/Subject Demographics
* /Download/Study Data/ ... DIAGNOSIS

UK Biobank data can be accessed using the [Research Analysis Platform (RAP)]().

## Risk Model

## Evaluation
