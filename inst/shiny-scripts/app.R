library(shiny)
library(DT)

# Define UI
ui <- fluidPage(

  # Change title
  titlePanel("DrugSeekR: Analyzing drug targets for personalized medicine"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(
      p("Description: DrugSeekR is an R package that analyzes genomic data
        in the format of MAF files to identify potential drug targets for
        personalized medicine through mutational frequency analysis,
        gene annotation,
        and drug target matching. It aims to provide a user-friendly
        and comprehensive
        workflow for finding personalized treatments based on genomic samples
        from patients."),
      br(),
      p("You can find a sample maf file in the inst/extdata folder!"),
      br(),
      fileInput("geneData",
                "Upload a .maf file",
                multiple = FALSE,
                accept = c('.gz'),
                width = NULL,
                buttonLabel = "Browse...",
                placeholder = "No file selected"),

      textOutput("uploadMaf"),

      br(),
      actionButton(inputId = "analyze", label = "Analyze File"),

      br(),
      textOutput("analysisText")

    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Mutation Frequency and Percentage",
                           h3("Instructions: upload and analyze the maf
                              file then click run at the bottom of this page"),
                           br(),
                           h3("Mutational frequencies in sample"),
                           br(),
                           tableOutput("mutationFrequencies"),
                           br(),
                           actionButton(inputId = "runFrequencies",
                                        label = "Run"),
                           ),
                  tabPanel("Annotated Gene Data",
                           h3("Instructions: upload and analyze the maf
                              file then click run at the bottom of this page"),
                           h3("Please note this function requires a stable
                              internet connection and takes a bit of time to
                              run, only click run ONCE"),
                           h2("You can choose to enter a number to only find
                              the top genes"),
                           numericInput(inputId = "annotatedNumber",
                                        label = "Number of Genes",
                                        value = 5,
                                        min = 1),
                           br(),
                           h3("Gene annotations of mutated genes"),
                           br(),
                           # tableOutput("annotatedGenes"),
                           DT::dataTableOutput("annotatedGenes"),
                           br(),
                           actionButton(inputId = "annotateGenes",
                                        label = "Run"),
                           ),
                  tabPanel("Gene Drug Targets",
                           h3("Instructions: upload and analyze the maf file
                              then click run at the bottom of this page"),
                           h2("You can choose to enter a number to only find
                              the top genes"),
                           numericInput(inputId = "drugTargetNumber",
                                        label = "Number of Genes",
                                        value = 5,
                                        min = 1),
                           br(),
                           h3("Genes and number of drugs that target them"),
                           br(),
                           tableOutput("geneDrugTargets"),
                           br(),
                           h3("Drug List"),
                           br(),
                           DT::dataTableOutput("drugList"),
                           br(),
                           actionButton(inputId = "drugTargets", label = "Run"),
                           ),
                  tabPanel("Plot of Druggable Genes",
                           h3("Instructions: upload and analyze the maf file
                              then click run at the bottom of this page"),
                           h2("You can choose to enter a number to only
                              find the top genes"),
                           numericInput(inputId = "plotNumber",
                                        label = "Number of Genes",
                                        value = 5, min = 1),
                           br(),
                           h3("Plot of Gene Drug Targets:"),
                           br(),
                           plotOutput("ouputPlot"),
                           br(),
                           actionButton(inputId = "plotTargets", label = "Run"),
                           )

      )
    )
  )
)

# Define server logic for random distribution app ----
server <- function(input, output) {

  # Uploading and reading maf file
  # Run readmaf
  geneSummary <- eventReactive(eventExpr = input$analyze, {
    maftools::getGeneSummary(maftools::read.maf(input$geneData$datapath))
  })

  output$analysisText <- renderText({
    if (input$analyze > 0 && !is.null(geneSummary())) {
      paste("You have successfully read the maf file")
    }
  })

  output$uploadMaf <- renderText({
    req(input$geneData)
    paste("You have successfully uploaded", input$geneData$name)
  })


  # Run MutationStatistics
  mutationFrequencies <- eventReactive(eventExpr = input$runFrequencies, {
    if (!is.null(geneSummary())) {
      return(DrugSeekR::calculateMutationFrequencies(geneSummary()))
    }
  })

  output$mutationFrequencies <- renderTable({
    if (!is.null(mutationFrequencies())) {
      return(mutationFrequencies())
    }
  }, rownames = TRUE)


  # Run geneAnnotations:
  annotatedGenes <- eventReactive(eventExpr = input$annotateGenes, {
    if (!is.null(geneSummary())) {
      return(DrugSeekR::annotateGenes(geneData = geneSummary(),
                                      number = input$annotatedNumber))
    }
  })

  output$annotatedGenes <- DT::renderDataTable({
    if (!is.null(annotatedGenes())) {
      return(annotatedGenes())
    }
  }, rownames = TRUE)

  #Run getGeneDrugTargets
  drugs <- eventReactive(eventExpr = input$drugTargets, {
    if (!is.null(geneSummary())) {
      return(DrugSeekR::getGeneDrugTargets(geneData = geneSummary(),
                                           number = input$drugTargetNumber))
    }
  })

  output$geneDrugTargets <- renderTable({
    if (!is.null(drugs())) {
      return(drugs()$mostDruggableGenes)
    }
  }, rownames = TRUE)

  output$drugList <- DT::renderDataTable({
    if (!is.null(drugs())) {
      return(drugs()$drugsThatTargetTheseGenes)
    }
  })

  # Run Plot Genes
  drugPlot <- eventReactive(eventExpr = input$plotTargets, {
    if (!is.null(geneSummary())) {
      geneCounts <- DrugSeekR::getGeneDrugTargets(geneData = geneSummary(),
                                                  number = input$plotNumber)
      return(geneCounts$mostDruggableGenes)
    }
  })

  output$ouputPlot <- renderPlot({
    if (!is.null(drugPlot())) {
      return(DrugSeekR::plotDruggableGenes(drugFrequencies = drugPlot()))
    }
  })

}

# Create Shiny app ----
shiny::shinyApp(ui, server)

# [END]
