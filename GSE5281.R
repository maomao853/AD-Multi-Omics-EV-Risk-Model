require(GEOquery)
require(Biobase)

### Get GEO dataset
gset <- getGEO("GSE5281", GSEMatrix=TRUE, getGPL=FALSE)
if (length(gset)>1) idx <- grep("GPL570", attr(gset, "names")) else idx <- 1
gset <- gset[[idx]]
#dim(exprs(gset))

### Get gene annotation data
require(biomaRt)
mart <- useMart("ENSEMBL_MART_ENSEMBL")
mart <- useDataset("hsapiens_gene_ensembl", mart)
annotLookup <- getBM(
  attributes=c("hgnc_symbol", "ensembl_gene_id", "affy_hg_u133_plus_2"),
  filters = "affy_hg_u133_plus_2",
  values = rownames(exprs(gset)),
  mart = mart
)

#head(rownames(gset))
#head(annotLookup)

### Match indices of gene ID - gene symbol in annotations
indicesLookup <- match(rownames(gset), annotLookup$affy_hg_u133_plus_2)
#head(annotLookup[indicesLookup, "hgnc_symbol"])

### Verify
#dftmp <- data.frame(rownames(gset), annotLookup[indicesLookup, c("affy_hg_u133_plus_2", "hgnc_symbol")])
#head(dftmp, 5)
#table(dftmp[,1] == dftmp[,2])

# Map gene ID to gene symbol
rownames(gset) <- paste(
  annotLookup[indicesLookup, "hgnc_symbol"],
  c(1:length(indicesLookup)),
  sep="_"
)

#head(rownames(gset),5)
#exprs(gset)[1:5,1:5]

### Output CSV file
df <- data.frame(gset)

output_file <- file.path(getwd(), "data", "GSE_data.csv")
write.csv(df, output_file)