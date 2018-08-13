plotSummaryNumbers <- function(data, samples, what = "raw total sequences:") {
  data = data %>% filter(sample %in% samples) %>% filter(description %in% what)
  ggplot(data = data, mapping = aes(x=sample, y=value, fill=sample)) +
    geom_bar(stat = "identity") +
    ylab(what) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))
}

plotInsertSize <- function(data, samples, log=FALSE, lims = c(0,400), sizeLimit = 75, combine = F) {
  color = rainbow(length(levels(data$sample)))
  names(color) = levels(data$sample)
  if (log) {
    data$pairs_total = log(data$pairs_total)
  }
  data = data %>%
    filter(insert_size >= sizeLimit) %>%
    filter(sample %in% samples)
  ggplot(data = data, mapping = aes(x=insert_size, y = pairs_total, color = sample)) +
    geom_line() +
    scale_colour_manual(values = color[as.character(data$sample)]) +
    xlim(lims) +
    xlab("Insert size") +
    ylab("Normalized read density * 10e-3")
}
