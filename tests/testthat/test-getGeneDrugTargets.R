library(DrugSeekR)

geneData <- data.frame(
  Hugo_Symbol = c("BRCA1", "BRCA2", "TP53", "KRAS", "EGFR"),
  Frame_Shift_Del = c(10, 15, 20, 25, 30),
  Frame_Shift_Ins = c(5, 10, 15, 20, 25),
  In_Frame_Del = c(15, 20, 25, 30, 35),
  Missense_Mutation = c(20, 25, 30, 35, 40),
  total = c(50, 70, 90, 110, 130)
)

test_that("getGeneDrugTargets returns the expected output", {
  result_no_number <- getGeneDrugTargets(geneData)
  result_number <- getGeneDrugTargets(geneData, number = 2)

  expect_type(result_no_number, "list")
  expect_length(result_no_number, 2)
  expect_named(result_no_number,
               c("mostDruggableGenes", "drugsThatTargetTheseGenes"))

  expect_equal(as.character(result_no_number$mostDruggableGenes$Gene.Var1),
               c("EGFR", "KRAS", "TP53", "BRCA1", "BRCA2"))
  expect_equal(as.character(result_number$mostDruggableGenes$Gene.Var1),
                  c("EGFR", "KRAS"))

})




