library(dplyr)
library(ggplot2)
library(minpack.lm)
library(shiny)


logs = list.files(path = "/home/mmigdal/Documents/sumsamstats", pattern = ".log$", full.names = TRUE) # Definetely add input for this
data = lapply(logs, readSamtoolsStats)
samples = gsub(".stats.log$", "", gsub(".*/", "", logs))

summaryNumbers = do.call(rbind, lapply(1:length(data), function(i) {
  data[[i]]$SN$sample = factor(samples[i])
  data[[i]]$SN
})) %>% mutate(value = as.numeric(value), description = gsub(":$", "", description))

insertSize = do.call(rbind, lapply(1:length(data), function(i) {
  data[[i]]$IS$sample = factor(samples[i])
  data[[i]]$IS
})) %>% mutate_if(is.character, as.numeric) %>% group_by(sample) %>% mutate(pairs_total = pairs_total/sum(pairs_total))

server <- function(input, output, session) {

    output$summaryInputSamples <- renderUI(checkboxGroupInput(inputId = "samplesSummaryNumbers",
                                  label = "Samples to show:",
                                  choices = unique(summaryNumbers$sample),
                                  selected = unique(summaryNumbers$sample)
    ))

    output$summaryInputProperty <- renderUI(selectInput(inputId = "what",
                                               label = "Property to plot:",
                                               choices = unique(summaryNumbers$description),
                                               selected = "raw total sequences:"
    ))

    output$summaryNumbersPlot <- renderPlot({

        plotSummaryNumbers(data = summaryNumbers, samples = input$samplesSummaryNumbers,
            what = input$what)
    })

    output$insertSizePlot <- renderPlot({

        plotInsertSize(data = insertSize, samples = input$samplesInsertSize, log = ifelse(input$scale == "log", T, F), lims = input$lims)
    })
}
