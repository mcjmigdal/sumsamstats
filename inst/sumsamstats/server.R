library(dplyr)
library(ggplot2)
library(minpack.lm)
library(shiny)

exampleInput <- c("/home/mmigdal/Documents/site_things/sumsamstats/sample1", "/home/mmigdal/Documents/site_things/sumsamstats/sample2",
                  "/home/mmigdal/Documents/site_things/sumsamstats/sample3", "/home/mmigdal/Documents/site_things/sumsamstats/sample4")

server <- function(input, output, session) {

    data <- reactive({
        paths <- input$inputFiles$datapath
        if (is.null(paths)) {
            paths <- exampleInput
        }
        lapply(paths, readSamtoolsStats)
    })  # TODO SET UP DEFAULT PATHs TO EXEMPLARY LOGS

    samples <- reactive({
        names <- input$inputFiles$name
        if (is.null(names)) {
            names <- exampleInput
        }
        gsub(".stats.txt$", "", gsub(".*/", "", names))
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
        if (length(input$limsInsertSize) == 0 || length(input$scaleInsertSize) == 0) {
          warning("One of input values to insertSizePlot was of length 0, returning NULL plot.")
          return(NULL)
        }
        useLogScale = ifelse(input$scaleInsertSize == "log", T, F)
        plotInsertSize(data = insertSize(), samples = input$samplesInsertSize, log = useLogScale, lims = input$limsInsertSize)
    })
}
