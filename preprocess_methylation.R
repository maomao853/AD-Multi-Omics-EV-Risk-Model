library(minfi)
library(sva)
library(IlluminaHumanMethylationEPICmanifest)
library(IlluminaHumanMethylationEPICanno.ilm10b4.hg19)

#'
#' Based on https://www.bioconductor.org/help/course-materials/2015/BioC2015/methylation450k.html
#'

###

#' Source: https://bioconductor.org/packages/release/bioc/html/TrajectoryUtils.html
rowmean <- function(x, group) {
  if (is.matrix(group)) {
    .rowstats_w(DelayedArray::DelayedArray(x), group, FUN=DelayedMatrixStats::colWeightedMeans)
  } else {
    .rowstats(x, group, FUN=colMeans)
  }
}

#' @export
#' @rdname rowmean
rowmedian <- function(x, group) {
  if (is.matrix(group)) {
    .rowstats_w(DelayedArray::DelayedArray(x), group, FUN=DelayedMatrixStats::colWeightedMedians)
  } else {
    .rowstats(DelayedArray::DelayedArray(x), group, FUN=DelayedMatrixStats::colMedians)
  }
}

.rowstats <- function(x, group, FUN, ...) {
  by.group <- split(seq_len(nrow(x)), group)
  output <- matrix(0, length(by.group), ncol(x), dimnames=list(names(by.group), colnames(x)))    
  for (i in seq_along(by.group)) {
    output[i,] <- FUN(x[by.group[[i]],,drop=FALSE], ...)
  }
  output
}

.rowstats_w <- function(x, group, FUN, ...) {
  group <- group/rowSums(group)
  output <- matrix(0, ncol(group), ncol(x), dimnames=list(.choose_colnames(group), colnames(x)))
  for (i in seq_len(ncol(group))) {
    output[i,] <- FUN(x, w=group[,i], ...)
  }
  output
}

.choose_colnames <- function(group) {
  vals <- colnames(group)
  if (is.null(vals)) {
    vals <- as.character(seq_len(ncol(group)))
  }
  vals
}

#' Process idat function
process_idat <- function(iteration, start, stop) {
  #' Select & read IDAT files -> RGChannelSet
  #'   RGSet = raw intensities in the green and red channels
  print("Reading methylation array...")
  RGSet <- read.metharray.exp(targets = targets[start:stop, ])
  
  #' Process RGChannelSet
  #'   MSet: MethylSet - contains only the methylated and unmethylated signals
  #'   RSet: RatioSet - contains Beta values and/or M values
  #'   GRSet: GenomicRatioSet - contains Beta values and/or M values + genomic coordinates
  print("Processing methylation array...")
  MSet <- preprocessRaw(RGSet) 
  RSet <- ratioConvert(MSet, what = "both", keepCN = TRUE)
  GRset <- mapToGenome(RSet)
  
  #' Get matrices of important values
  print("Collecting beta values...")
  beta <- getBeta(GRset)
  print(paste("total: ", length(rownames(beta))))
  print(paste("unique: ", length(unique(rownames(beta)))))

  #' Full annotation
  print("Collecting annotation data...")
  annotation <- getAnnotation(GRset)
  annotation_df <- as.data.frame(annotation["UCSC_RefGene_Name"])

  #' Replace row names with gene symbol using acquired indices
  print("Converting row names...")
  indicesLookup <- match(rownames(beta), rownames(annotation_df))
  rownames(beta) <- annotation_df[indicesLookup, "UCSC_RefGene_Name"]
  
  #' Drop all rows with "na" value
  print("Processing row names...")
  beta_notna <- beta[rownames(beta) != "", ]
  beta_mean <- rowmean(beta_notna, row.names(beta_notna))
  beta_df <- as.data.frame(beta_mean)
  
  print(paste("total: ", length(rownames(beta_df))))
  print(paste("unique: ", length(unique(rownames(beta_df)))))
  
  print("Writing CSV file...")
  output_file <- file.path(wd, "data", paste0("beta_", iteration, ".csv"))
  write.csv(beta_df, output_file, row.names=TRUE)
}

###

#' Set working & data directory
wd <- getwd()
data_dir <- file.path(wd, "data", "ADNI_iDAT_files")

#' Loop over the total 1919 samples, 3838 files
targets <- read.metharray.sheet(data_dir)
step_size <- 100
steps <- as.integer(ceiling(length(targets$barcodes)/step_size))

for(i in 1:steps) {
  start <- (i-1)*step_size+1
  stop <- i*step_size
  if(i == steps) {
    stop <- length(targets$barcodes)
  }
  print(paste(start, " - ", stop))
  process_idat(i, start, stop)
}