library(DrugSeekR)

geneData <- data.frame(
  Hugo_Symbol = c("BRCA1", "BRCA2", "TP53", "KRAS", "EGFR"),
  Frame_Shift_Del = c(10, 15, 20, 25, 30),
  Frame_Shift_Ins = c(5, 10, 15, 20, 25),
  In_Frame_Del = c(15, 20, 25, 30, 35),
  Missense_Mutation = c(20, 25, 30, 35, 40),
  total = c(50, 70, 90, 110, 130)
)

returnData <- annotateGenes(geneData)
returnDataNumber <- annotateGenes(geneData, number = 2)

test_that("annotateGenes works as expected", {
  # Test the output type
  expect_type(returnData, "list")

  # Test the output length
  expect_length(returnData, 6)

  # Test the output values
  expect_setequal(returnData$geneAnnotations.hgnc_symbol, c("BRCA1", "BRCA2", "TP53", "KRAS", "EGFR"))

  expect_equal(returnDataNumber$geneAnnotations.hgnc_symbol, c("EGFR", "KRAS"))
})
