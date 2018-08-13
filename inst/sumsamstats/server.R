server <- function(input, output) {
    
    logs = list.files(path = input$path, pattern = ".log$", full.names = TRUE)
    data = lapply(logs, readSamtoolsStats)
    samples = gsub(".stats.log$", "", gsub(".*/", "", logs))
    
    
    output$summaryNumbersPlot <- renderPlot({
        summaryNumbers = do.call(rbind, lapply(1:length(data), function(i) {
            data[[i]]$SN$sample = factor(samples[i])
            data[[i]]$SN
        })) %>% mutate(value = as.numeric(value))
        
        plotSummaryNumbers(data = summaryNumbers, samples = input$samplesSummaryNumbers, 
            what = input$what)
    })
    
    output$insertSizePlot <- renderPlot({
        insertSize = do.call(rbind, lapply(1:length(data), function(i) {
            data[[i]]$IS$sample = factor(samples[i])
            data[[i]]$IS
        })) %>% mutate_if(is.character, as.numeric) %>% group_by(sample) %>% mutate(pairs_total = pairs_total/sum(pairs_total))
        
        if (input$fit) {
            plotInsertSize(data = insertSize, samples = input$samplesInsertSize, log = ifelse(input$scale == 
                "log", T, F), lims = input$lims) + plotMixedFun(insertSize$insert_size, 
                input$a, input$b, input$k, input$mean, input$sd) + ylim(c(0, 0.015))
        } else {
            plotInsertSize(data = insertSize, samples = input$samplesInsertSize, log = ifelse(input$scale == 
                "log", T, F), lims = input$lims)
        }
    })
    
}
