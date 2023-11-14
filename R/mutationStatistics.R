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
#' # Using maftools maf data available with package
#' laml.maf <- system.file('extdata', 'tcga_laml.maf.gz', package = 'maftools')
#' laml <- maftools::read.maf(maf = laml.maf)
#' geneSummary <- maftools::getGeneSummary(laml)
#'
#' # Calculate Mutation Frequency and Percentage
#' mutationStatistics <- calculateMutationFrequencies(geneSummary)
#' mutationStatistics
#'
#' @references
#' Mayakonda A, Lin DC, Assenov Y, Plass C, Koeffler HP. 2018. Maftools:
#' efficient and comprehensive analysis of somatic variants in cancer. Genome
#' Research. http://dx.doi.org/10.1101/gr.239244.118
#'
#' @export
#' @import maftools
calculateMutationFrequencies <- function(geneData) {
  mutationSums <- colSums(geneData[, -1])

  total <- sum(geneData$total)
  percentages <- mutationSums / total * 100
  percentages <- round(percentages, 2)

  return(list(numberOfMutations = mutationSums,
              mutationByPercentage = percentages))
}
