ui <- fluidPage(
  fluidRow(
    inputPanel(
      checkboxGroupInput(inputId = "samplesSummaryNumbers",
                       label = "Samples to show:",
                       choices = unique(summaryNumbers$sample),
                       selected = unique(summaryNumbers$sample)
      ),
      selectInput(inputId = "what",
                label = "Property to plot:",
                choices = unique(summaryNumbers$description),
                selected = "raw total sequences:"
      )
    )
  ),

  plotOutput(outputId = "summaryNumbersPlot"),

  hr(),

  fluidRow(
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
      ),
    )
  ),

  plotOutput(outputId = "insertSizePlot")

)
