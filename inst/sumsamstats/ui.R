ui <- fluidPage(

  titlePanel("Hello!"),

  inputPanel(
    checkboxGroupInput(inputId = "samplesSummaryNumbers",
                     label = "Samples to show:",
                     choices = c("a", "b"),
                     selected = "a"
    ),
    selectInput(inputId = "what",
              label = "Property to plot:",
              choices = "ABC",
              selected = "raw total sequences:"
    )
  )
)
