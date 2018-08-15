server <- function(input, output, session) {
    output$summaryNumbersPlot <- renderPlot({

        plotSummaryNumbers(data = summaryNumbers, samples = input$samplesSummaryNumbers,
            what = input$what)
    })

    output$insertSizePlot <- renderPlot({
      
        plotInsertSize(data = insertSize, samples = input$samplesInsertSize, log = ifelse(input$scale == "log", T, F), lims = input$lims)
    })
}
