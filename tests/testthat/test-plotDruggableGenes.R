library(DrugSeekR)

drugFrequencies <- data.frame(
  gene = c("BRCA1", "TP53", "EGFR", "KRAS", "BRAF"),
  frequency = c(12, 10, 8, 6, 4)
)

test_that("plotDruggableGenes function works as expected", {
  # Test that the function returns a ggplot object
  plot <- plotDruggableGenes(drugFrequencies)
  buildPlot <- ggplot_build(plot)
  expect_type(plot, "list")

  # Correct number of bars
  expect_equal(length(buildPlot$data[[1]]$x), 5)

  # Correct values of drugCount
  expect_equal(buildPlot$data[[1]]$y, drugFrequencies$frequency)
})

