library(dplyr)
library(ggplot2)
library(minpack.lm)
library(shiny)

logs = list.files(path = "/home/mmigdal/Documents/site_things/sumsamstats", pattern = ".log$", full.names = TRUE)
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
