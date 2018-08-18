ui <- navbarPage(title="Summary of samtools stats output",


    tabPanel("Home",
             h1("Summary of samtools stats output"),
             fileInput(inputId = "inputFiles", label = "Input files", multiple = TRUE)
    ),

    tabPanel("Summary statistics",
      uiOutput(outputId = "summaryInputSamples"),

      uiOutput(outputId = "summaryInputProperty"),

      plotOutput(outputId = "summaryNumbersPlot")
    ),

  tabPanel("Insert size distribution",


    inputPanel(
      uiOutput(outputId = "samplesInsertSize"),
      uiOutput(outputId = "scaleInsertSize"),
      uiOutput(outputId = "limsInsertSize")
    ),


  plotOutput(outputId = "insertSizePlot")

)
)
