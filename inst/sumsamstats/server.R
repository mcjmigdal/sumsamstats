server <- function(input, output, session) {
    output$summaryNumbersPlot <- renderPlot({

        plotSummaryNumbers(data = summaryNumbers, samples = input$samplesSummaryNumbers,
            what = input$what)
    })

    output$insertSizePlot <- renderPlot({

        if (input$fit) {
            plotInsertSize(data = insertSize, samples = input$samplesInsertSize, log = ifelse(input$scale ==
                "log", T, F), lims = input$lims) + plotMixedFun(x = seq(min(insertSize$insert_size), max(insertSize$insert_size), length.out = 1000),
                input$a, input$b, input$k1, input$mean1, input$sd1, input$k2, input$mean2, input$sd2, input$k3, input$mean3, input$sd3) + ylim(c(0, 0.02))
        } else {
            if (input$nls) {

            } else {
              plotInsertSize(data = insertSize, samples = input$samplesInsertSize, log = ifelse(input$scale == "log", T, F), lims = input$lims)
            }
        }
    })
}
