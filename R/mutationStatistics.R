#' Calculates Mutation Frequency and Percentage
#'
#' A function that calculates
#' the frequency of observed mutations within a sample and their percentages
#'
#' @param geneData A list of genetic data returned from the maftools
#'    getGeneSummary function
#'
#'
#' @return returns a list of two elements: the number of mutations for
#'    each gene and the mutation percentage for each gene.
#'
#' @examples
#' # Example 1:
#' # Using maftools maf data available with package. It contains a maf file
#' # with data from a paper studying adult acute myeloid leukemia
#' laml.maf <- system.file('extdata', 'tcga_laml.maf.gz', package = 'maftools')
#' laml <- maftools::read.maf(maf = laml.maf)
#' geneSummary <- maftools::getGeneSummary(laml)
#'
#' # Calculate Mutation Frequency and Percentage
#' mutationStatistics <- calculateMutationFrequencies(geneSummary)
#' mutationStatistics
#'
#' @references
#' Cancer Genome Atlas Research, N. Genomic and epigenomic landscapes of adult de novo acute myeloid leukemia.
#'  N Engl J Med 368, 2059-74. 2013
#'
#' Mayakonda A, Lin DC, Assenov Y, Plass C, Koeffler HP. 2018. Maftools:
#' efficient and comprehensive analysis of somatic variants in cancer. Genome
#' Research. http://dx.doi.org/10.1101/gr.239244.118
#'
#' @export
#' @import maftools
calculateMutationFrequencies <- function(geneData) {
  if (!is.data.frame(geneData)) {
    stop("Input must be a data frame")
  }

  required_columns <- c('Hugo_Symbol', 'MutatedSamples'
  )

  if (!all(required_columns %in% colnames(geneData))) {
    stop("Input data frame must contain all required columns")
  }

  # sum the columns
  mutationSums <- colSums(geneData[, -1])

  # calculate percentages
  total <- sum(geneData$total)
  percentages <- mutationSums / total * 100
  percentages <- round(percentages, 2)

  return(list(numberOfMutations = mutationSums,
              mutationByPercentage = percentages))
}
