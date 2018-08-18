library(dplyr)
library(ggplot2)
library(minpack.lm)
library(shiny)

exampleInput = list.files("/home/mmigdal/Documents/sumsamstats/", ".log$", full.names = T)

server <- function(input, output, session) {

    data = reactive({
        paths <- input$inputFiles$datapath
        if (is.null(paths)) {
            paths = exampleInput
        }
        lapply(paths, readSamtoolsStats)
    })  # TODO SET UP DEFAULT PATHs TO EXEMPLARY LOGS

    samples = reactive({
        names <- input$inputFiles$name
        if (is.null(names)) {
            names = exampleInput
        }
        gsub(".*/", "", names)
    })

    summaryNumbers = reactive(do.call(rbind, lapply(1:length(data()), function(i) {
        df = data()
        df[[i]]$SN$sample = factor(samples()[i])
        df[[i]]$SN
    })) %>% mutate(value = as.numeric(value), description = gsub(":$", "", description)))

    insertSize = reactive(do.call(rbind, lapply(1:length(data()), function(i) {
        df = data()
        df[[i]]$IS$sample = factor(samples()[i])
        df[[i]]$IS
    })) %>% mutate_if(is.character, as.numeric) %>% group_by(sample) %>% mutate(pairs_total = pairs_total/sum(pairs_total)))


    output$summaryInputSamples <- renderUI(checkboxGroupInput(inputId = "samplesSummaryNumbers", label = "Samples to show:", choices = unique(summaryNumbers()$sample),
        selected = unique(summaryNumbers()$sample)))

    output$summaryInputProperty <- renderUI(selectInput(inputId = "what", label = "Property to plot:", choices = unique(summaryNumbers()$description),
        selected = "raw total sequences:"))

    output$summaryNumbersPlot <- renderPlot({
        plotSummaryNumbers(data = summaryNumbers(), samples = input$samplesSummaryNumbers, what = input$what)
    })

    output$samplesInsertSize <- renderUI(checkboxGroupInput(inputId = "samplesInsertSize", label = "Samples to show:", choices = unique(summaryNumbers()$sample),
        selected = unique(summaryNumbers()$sample)))

    output$scaleInsertSize <- renderUI(selectInput(inputId = "scaleInsertSize", label = "Scale:", choices = c("normal", "log"), selected = "normal"))

    output$limsInsertSize <- renderUI(sliderInput(inputId = "limsInsertSize", label = "Range:", min = 0, max = 2000, value = c(0, 400)))

    output$insertSizePlot <- renderPlot({
        plotInsertSize(data = insertSize(), samples = input$samplesInsertSize, log = ifelse(input$scaleInsertSize == "log", T, F), lims = input$limsInsertSize)
    })
}
