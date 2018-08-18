ui <- navbarPage(title="Summary of samtools stats output",


    tabPanel("Home",
             h1("Summary of samtools stats output"),
             shinyDirButton(id = "inputDir", label = "Input directory", title = "")
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
