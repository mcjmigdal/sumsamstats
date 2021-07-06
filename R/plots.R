#' Plot Summary Numbers
#'
#' plotSummaryNumbers plots properties from Summary Numbers (SN) part of output returned
#' by \code{\link{readSamtoolsStats}}. This includes number of mapped reads, mapped and paired reads,
#' and alignment rate (see details for compleate list). Function also provides means to plot some
#' properties that are not explicitly available in the output.
#'
#' @param data Summary Numbers (SN) part of output returned by \code{\link{readSamtoolsStats}}
#' or formated data frame of values to plot.
#'
#' @param samples vector of samples names from data that are required to be plotted.
#'
#' @param what string describing property to plot. Valid choices includes all properties from
#' Summary Numbers (SN) part of output returned by \code{\link{readSamtoolsStats}} and additionaly
#' 'alignment rate'.
#'
#' @examples
#' SN <- readSamtoolsStats(system.file('extdata', 'sample1', package = 'sumsamstats'))
#' plotSummaryNumbers(data = SN, samples = c('sample1'), what = 'raw total sequences')
#'
#' @import dplyr
#' @import ggplot2
#' @import grDevices
#'
#' @export
plotSummaryNumbers <- function(data, samples, what = "raw total sequences") {
    if (what == "alignment rate") {
      data <- dplyr::filter(data, sample %in% samples) %>%
        dplyr::filter(description %in% c("reads mapped", "reads unmapped")) %>%
        dplyr::group_by(sample) %>%
        dplyr::summarise(value = value[description == 'reads mapped'] / sum(value))
    } else {
      data <- dplyr::filter(data, sample %in% samples) %>%
        dplyr::filter(description %in% what)
    }
    ggplot(data = data, mapping = aes(x = sample, y = value, fill = sample)) +
      geom_bar(stat = "identity") +
      ylab(what) +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
      # {if(what %in% c("reads mapped and paired")) geom_hline(yintercept = 50e6, linetype = "dashed", color = 'black')}
}

#' Plot Insert Size Samtools Stat section
#'
#' plotInsertSize plots Insert Size (IS) part of output returned by
#' \code{\link{readSamtoolsStats}}.
#'
#' @param data Insert Size (IS)) part of output returned by \code{\link{readSamtoolsStats}}
#' or formated data frame of values to plot.
#'
#' @param samples vector of samples names from data that are required to be plotted.
#'
#' @param log logical value indicating if data should be log transformed before plotting.
#'
#' @param lims two element vector specifing x-axis limists.
#'
#' @param sizeLimit lower limit on insert size. Data below this limit will be filtered out.
#'
#' @examples
#' IS <- readSamtoolsStats()
#' plotInsertSize <- function(data, samples, log = FALSE, lims = c(0, 400), sizeLimit = 75)
#'
#' @import dplyr
#' @import ggplot2
#' @import colorspace
#'
#' @export
plotInsertSize <- function(data, samples, log = FALSE, lims = c(0, 400), sizeLimit = 0) {
    color <- colorspace::rainbow_hcl(length(levels(data$sample)))
    names(color) <- levels(data$sample)
    if (log) {
        data$pairs_total <- log(data$pairs_total)
    }
    data <- data %>% dplyr::filter(insert_size >= sizeLimit) %>% dplyr::filter(sample %in% samples)
    ggplot(data = data, mapping = aes(x = insert_size, y = pairs_total, color = sample)) +
      geom_line() +
      scale_colour_manual(values = color[as.character(data$sample)]) +
      xlim(lims) +
      xlab("Insert size") +
      ylab("Normalized read density * 10e-3")
}
