ui <- navbarPage(title="ATAC-seq quality control",


    tabPanel("Input files",
             h1("Samtools stats based ATAC-seq quality control"),
             p("This app summarises output of samtools stats in a way that allows quick inspection of ATAC-seq libraries quality,
               quality standards were taken from", a(href="https://www.encodeproject.org/atac-seq", "ENCODE website.")),
             br(),
             p("By default app preloads exemplary input files, so you might explore it! Just select any other tab above."),
             p("If you prefer to check quality of your libraries provide outputs from samtools stats below."),
             br(),
             fileInput(inputId = "inputFiles", label = "Input files:", multiple = TRUE),
             hr(),
             h3("ENCODE ATAC-seq quality standards:"),
             tags$ul(
               tags$li("two or more biological replicates"),
               tags$li("at least 25 million fragments"),
               tags$li("aligment rate greater than 95%"),
               tags$li("replicate concordance measured by calculating IDR values"),
               tags$li("library complexity measured using Non-Redundant Fraction and PCR Bottlenecking Coefficients 1 and 2. NRF > 0.9, PBC1 > 0.9, PBC2 > 3"),
               tags$li("mononucleosome peak must be present in the fragment length distribution"),
               tags$li("FRiP > 0.3"),
               tags$li("TSS enrichment")
             )
    ),

    tabPanel("Summary statistics",
      inputPanel(
        uiOutput(outputId = "summaryInputSamples"),
        uiOutput(outputId = "summaryInputProperty")

      ),
      plotOutput(outputId = "summaryNumbersPlot")
    ),

  tabPanel("Insert size distribution",


    inputPanel(
      uiOutput(outputId = "samplesInsertSize"),
      uiOutput(outputId = "scaleInsertSize"),
      uiOutput(outputId = "limsInsertSize"),

      tags$div(
        actionButton(inputId = "addGauss",
                   label = "Add gaussian"),
        actionButton(inputId = "removeGauss",
                   label = "Remove gaussian")
      ),
      numericInput(inputId = "expa",
                   label = "a",
                   value = 0.1,
                   step = 0.1
      ),
      numericInput(inputId = "expb",
                   label = "b",
                   value = -0.02,
                   step = 0.01
      ),
      tags$div(id = "fitParams")
    ),


  plotOutput(outputId = "insertSizePlot")

)
)
