library(dplyr)
library(ggplot2)
library(minpack.lm)
library(shiny)
library(shinyFiles)

server <- function(input, output, session) {

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


    shinyDirChoose(input, 'inputDir', roots = c(home = '~'), filetypes = c('', 'txt'))

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

    output$samplesInsertSize <- renderUI(checkboxGroupInput(inputId = "samplesInsertSize",
                       label = "Samples to show:",
                       choices = unique(summaryNumbers$sample),
                       selected = unique(summaryNumbers$sample)
    ))

    output$scaleInsertSize <- renderUI(selectInput(inputId = "scaleInsertSize",
                label = "Scale:",
                choices = c("normal", "log"),
                selected = "normal"
    ))

    output$limsInsertSize <- renderUI(sliderInput(inputId = "limsInsertSize",
                label = "Range:",
                min = 0, max = 2000,
                value = c(0,400))
    )

    output$insertSizePlot <- renderPlot({
        plotInsertSize(data = insertSize, samples = input$samplesInsertSize, log = ifelse(input$scaleInsertSize == "log", T, F), lims = input$limsInsertSize)
    })
}
