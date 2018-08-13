ui <- fluidPage(
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
  ),

  mainPanel(
    plotOutput(outputId = "summaryNumbersPlot")
  ),

  inputPanel(
    checkboxGroupInput(inputId = "samplesInsertSize",
                       label = "Samples to show:",
                       choices = unique(insertSize$sample),
                       selected = unique(insertSize$sample)
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
    checkboxGroupInput(inputId = "fit",
                       label = "Fitt mixed function:",
                       choices = c(TRUE, FALSE),
                       selected = c(FALSE)
    ),
    sliderInput(inputId = "a",
                label = "a",
                min = -1, max = 1,
                value = 0.01, step = 0.001
    ),
    sliderInput(inputId = "b",
                label = "b",
                min = -1, max = 1,
                value = -0.01, step = 0.001
    ),
    sliderInput(inputId = "k",
                label = "k",
                min = 0, max = 1,
                value = 0.005, step = 0.001
    ),
    sliderInput(inputId = "mean",
                label = "mean",
                min = 0, max = 2000,
                value = 200, step = 50
    ),
    sliderInput(inputId = "sd",
                label = "sd",
                min = 0, max = 200,
                value = 50, step = 10
    )
  ),

  mainPanel(
    plotOutput(outputId = "insertSizePlot")
  )
)
