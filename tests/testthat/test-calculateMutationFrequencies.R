library(DrugSeekR)

geneData <- data.frame(
  Hugo_Symbol = c("BRCA1", "BRCA2", "TP53", "KRAS", "EGFR"),
  Frame_Shift_Del = c(10, 15, 20, 25, 30),
  Frame_Shift_Ins = c(5, 10, 15, 20, 25),
  In_Frame_Del = c(15, 20, 25, 30, 35),
  Missense_Mutation = c(20, 25, 30, 35, 40),
  total = c(50, 70, 90, 110, 130)
)

test_that("calculateMutationFrequencies works as expected", {
  # Test the output type
  expect_type(calculateMutationFrequencies(geneData), "list")

  # Test the output length
  expect_length(calculateMutationFrequencies(geneData), 2)

  # Test the output names
  expect_named(calculateMutationFrequencies(geneData),
               c("numberOfMutations", "mutationByPercentage"))

  # Test the output values
  expect_equal(calculateMutationFrequencies(geneData)$numberOfMutations,
               c(100,
                 75,
                 125,
                 150,
                 450))
  expect_equal(calculateMutationFrequencies(geneData)$mutationByPercentage,
               c(22.22,
                 16.67,
                 27.78,
                 33.33,
                 100.00))
})
