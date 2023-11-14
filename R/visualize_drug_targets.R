#' Plot druggable genes
#'
#' This function takes a named vector of drug frequencies for each gene and
#'  returns a bar plot of the number of drugs for each gene.
#'
#' @param drugFrequencies A named vector of drug frequencies for each gene.
#'
#' @return A ggplot object of a bar plot of the number of drugs for each gene.
#'
#' @examples
#' # Example 1:
#' # Use gene data provided from the maftools package
#' laml.maf <- system.file('extdata', 'tcga_laml.maf.gz', package = 'maftools')
#' laml <- maftools::read.maf(maf = laml.maf)
#' geneSummary <- maftools::getGeneSummary(laml)
#'
#' drugTargets <- DrugSeekR::getGeneDrugTargets(geneSummary)
#' plotDruggableGenes(drugTargets$mostDruggableGenes)
#'
#' @references
#' H. Wickham. ggplot2: Elegant Graphics for Data Analysis.
#'  Springer-Verlag New York, 2016.
#'
#' @export
#' @import ggplot2
plotDruggableGenes <- function(drugFrequencies) {
  gene <- NULL
  drugCount <- NULL
  geneCounts <- as.data.frame(drugFrequencies)

  colnames(geneCounts) <- c("gene", "drugCount")
  ggplot2::ggplot(geneCounts, aes(x = gene, y = drugCount)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    labs(title = "Number of drugs for each gene",
         x = "Gene",
         y = "Drug count") +
    theme_minimal()
}
