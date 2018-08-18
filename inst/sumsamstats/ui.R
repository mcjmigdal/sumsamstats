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

  hr(),

  tabPanel("Insert size distribution",


    inputPanel(
      checkboxGroupInput(inputId = "samplesInsertSize",
                       label = "Samples to show:",
                       choices = unique(summaryNumbers$sample),
                       selected = unique(summaryNumbers$sample)
      ),
      selectInput(inputId = "scale",
                label = "Scale:",
                choices = c("normal", "log"),
                selected = "normal"
      ),
      sliderInput(inputId = "lims",
                label = "Range:",
                min = 0, max = 2000,
                value = c(0,400)),
      checkboxInput(inputId = "fit",
                       label = "Fitt mixed function:",
                       value = FALSE
      )
    ),


  plotOutput(outputId = "insertSizePlot")

)
)
