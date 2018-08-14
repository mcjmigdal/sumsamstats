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
      numericInput(inputId = "a",
                label = "a",
                min = -1, max = 1,
                value = 0.065, step = 0.001
      ),
      numericInput(inputId = "b",
                label = "b",
                min = -1, max = 1,
                value = -0.018, step = 0.001
      ),
      numericInput(inputId = "k1",
                label = "k1",
                min = 0, max = 1,
                value = 0.003, step = 0.001
      ),
      numericInput(inputId = "mean1",
                label = "mean1",
                min = 0, max = 2000,
                value = 200, step = 50
      ),
      numericInput(inputId = "sd1",
                label = "sd1",
                min = 0, max = 200,
                value = 30, step = 10
      ),
      numericInput(inputId = "k2",
                   label = "k2",
                   min = 0, max = 1,
                   value = 0.001, step = 0.001
      ),
      numericInput(inputId = "mean2",
                   label = "mean2",
                   min = 0, max = 2000,
                   value = 200, step = 50
      ),
      numericInput(inputId = "sd2",
                   label = "sd2",
                   min = 0, max = 200,
                   value = 400, step = 10
      ),
      numericInput(inputId = "k3",
                   label = "k3",
                   min = 0, max = 1,
                   value = 0.001, step = 0.001
      ),
      numericInput(inputId = "mean3",
                   label = "mean3",
                   min = 0, max = 2000,
                   value = 600, step = 50
      ),
      numericInput(inputId = "sd3",
                   label = "sd3",
                   min = 0, max = 200,
                   value = 50, step = 10
      ),
      actionButton("nls", "Start nls fit")
    )
  ),

  plotOutput(outputId = "insertSizePlot")

)
