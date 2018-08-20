#' Plot Summary Numbers Samtools Stat section
#'
#' plotSummaryNumbers plots Summary Numbers (SN) part of output returned by
#' \code{\link{readSamtoolsStats}}.
#'
#' @param data Summary Numbers (SN) part of output returned by \code{\link{readSamtoolsStats}}
#' or formated data frame of values to plot.
#'
#' @param samples vector of samples names from data that are required to be plotted.
#'
#' @param what string describing property to plot from Summary Numbers.
#'
#' @examples
#' SN <- readSamtoolsStats()
#' plotSummaryNumbers(data = SN, samples = c("sample1", "sample2"), what = "raw total sequences")
#'
#' @import ggplot2
#'
#' @export
plotSummaryNumbers <- function(data, samples, what = "raw total sequences") {
    data = data %>% filter(sample %in% samples) %>% filter(description %in% what)
    ggplot(data = data, mapping = aes(x = sample, y = value, fill = sample)) + geom_bar(stat = "identity") + ylab(what) + theme(axis.text.x = element_text(angle = 90,
        hjust = 1))
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
#' @import ggplot2
#'
#' @export
plotInsertSize <- function(data, samples, log = FALSE, lims = c(0, 400), sizeLimit = 75) {
    color = rainbow(length(levels(data$sample)))
    names(color) = levels(data$sample)
    if (log) {
        data$pairs_total = log(data$pairs_total)
    }
    data = data %>% filter(insert_size >= sizeLimit) %>% filter(sample %in% samples)
    ggplot(data = data, mapping = aes(x = insert_size, y = pairs_total, color = sample)) + geom_line() + scale_colour_manual(values = color[as.character(data$sample)]) +
        xlim(lims) + xlab("Insert size") + ylab("Normalized read density * 10e-3")
}
