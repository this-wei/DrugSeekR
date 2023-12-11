#' Annotate genes
#'
#' This function takes a data frame of gene data and returns a list of gene
#' annotations and number of mutations for the top genes.
#' NOTE: This function requires a stable internet connection to run as it
#' queries the ensembl database for gene annotations.
#'
#' @param geneData A data frame or list of gene data and must contain column
#' names Hugo_Symbol and total.
#' @param number An integer specifying the number of top genes to annotate.
#' Default is NULL which will annotate all genes.
#' @param refDataset A string representing the species that you want to
#' identify the genes.
#' Available datasets can be listed using biomaRt::listDatasets()
#' Default is "hsapiens_gene_ensembl".
#'
#' @return A list with two elements:
#' \itemize{
#'   \item geneAnnotations: A data frame of gene annotations from biomaRt
#'   with columns hgnc_symbol, ensembl_gene_id, chromosome_name, start_position,
#'   end_position, and description.
#' }
#'
#' @examples
#' # Example 1
#' # Use gene data provided from the maftools package. It contains a maf file
#' # with data from a paper studying adult acute myeloid leukemia
#' laml.maf <- system.file('extdata', 'tcga_laml.maf.gz', package = 'maftools')
#' laml <- maftools::read.maf(maf = laml.maf)
#' geneSummary <- maftools::getGeneSummary(laml)
#' annotateGenes(geneData = geneSummary, number = 5)
#'
#' @references
#' Cancer Genome Atlas Research, N. Genomic and epigenomic landscapes of adult de novo acute myeloid leukemia.
#'  N Engl J Med 368, 2059-74. 2013
#'
#' Mapping identifiers for the integration of genomic datasets with the
#' R/Bioconductor package biomaRt.
#' Steffen Durinck, Paul T. Spellman, Ewan Birney and
#' Wolfgang Huber, Nature Protocols 4, 1184-1191 (2009).
#'
#' BioMart and Bioconductor: a powerful link between biological databases and
#' microarray data analysis. Steffen Durinck, Yves Moreau, Arek Kasprzyk, Sean
#' Davis, Bart De Moor, Alvis Brazma and Wolfgang Huber,
#' Bioinformatics 21, 3439-3440 (2005).
#'
#' @export
#' @import biomaRt
annotateGenes <- function(geneData,
                          number = NULL,
                          refDataset = "hsapiens_gene_ensembl") {
  if (!is.data.frame(geneData)) {
    stop("Input must be a data frame")
  }

  required_columns <- c('Hugo_Symbol', 'total'
  )

  if (!all(required_columns %in% colnames(geneData))) {
    stop("Input data frame must contain all required columns")
  }


  sorted <- geneData[order(-geneData$total), ]
  # Check if user specified a number
  if (!is.null(number)) {
    top <- sorted[1:number, ]
    genes <- top$Hugo_Symbol
  }
  else {
    genes <- sorted$Hugo_Symbol
  }

  ensembl <- biomaRt::useEnsembl(biomart = "genes", dataset = refDataset)

  filters <- "hgnc_symbol"
  attributes <- c("hgnc_symbol",
                  "ensembl_gene_id",
                  "chromosome_name",
                  "start_position",
                  "end_position",
                  "description")
  results <- biomaRt::getBM(filters = filters,
                            attributes = attributes,
                            values = genes,
                            mart = ensembl)


  return(data.frame(geneAnnotations = results))
}
