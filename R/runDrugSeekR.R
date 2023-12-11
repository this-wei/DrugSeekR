#' Launch Shiny App for DrugSeekR
#'
#' A function that launches the Shiny app for DrugSeekR.
#' The code for the app can be found in \code{./inst/shiny-scripts}.
#'
#' @return No return value but open up a Shiny page.
#'
#' @examples
#' \dontrun{
#'
#' DrugSeekR::runDrugSeekR()
#' }
#'
#' @export
#' @importFrom shiny runApp

runDrugSeekR <- function() {
  appDir <- system.file("shiny-scripts",
                        package = "DrugSeekR")
  actionShiny <- shiny::runApp(appDir, display.mode = "normal")
  return(actionShiny)
}
# [END]
