#' Parse samtools stat output
#'
#' readSamtoolsStats parses output of samtools stat making it easy to
#' work with it in R.
#'
#' @param file the name of the file which the data are to be read from. File must be
#' of type \code{character}, providing path to input file. If it does not provide an
#' absolute path(s), the file name is relative to the current working directory, \code{getwd()}.
#'
#' @return list of data frames holding data from different parts of \code{samtools stat} output.
#'
#' @examples
#' readSamtoolsStats(file = "path/to/samtools/stats/output")
#'
#' @export
readSamtoolsStats <- function(file) {
    if (!is.character(file)) {
        stop("File argument must be of class character!\n")
    }
    if (!file.exists(file)) {
        stop(paste0("File '", file, "' doesn't exists!\n"))
    }

    stats <- list()
    inputFile <- readLines(file)
    toExtract <- list(pattern = list("SN", "IS"), columns = list(c(2, 3), c(2, 3)), col.names = list(c("description", "value"), c("insert_size", "pairs_total")))

    for (i in 1:2) {
        stats[[toExtract$pattern[[i]]]] <- .grepData(inputFile, paste("^", toExtract$pattern[[i]], sep = ""), columns = toExtract$columns[[i]], col.names = toExtract$col.names[[i]])
    }
    return(stats)
}

#' Helper function for parsing output of samtools stats
#'
#' As readSamtoolsStats parses output of samtools stat this function is used to grep relevant
#' parts of the output.
#'
#' @param input A character vector containing output of samtools stats, each line as one element.
#'
#' @param section A pattern to extract from the report. Each section of samtools stats report is uniquley
#' labeled, for example Summary Numbers are labeled as SN. Currently supported sections: SN, IS.
#'
#' @param columns A integer vector containing numbers of columns to extract from specified section of samtools
#' stats report.
#'
#' @param col.names A character vector containing names of extracted columns. Optional.
#'
#' @return data frame holding data from selected section of \code{samtools stat} output.
#'
#' @examples
#' file <- "path/to/samtools/stats/output"
#' inputFile <- readLines(file)
#' .grepData(input=inputFile, section="SN", columns=c(2,3), col.names=c("description", "value"))
#'
.grepData <- function(input, section, columns, col.names = "") {
  if (! section %in% c("SN", "IS")) {
    stop(paste0("Parsing '", section, "' is not supported!"))
  }
  handle <- strsplit(input[grep(pattern = section, input)], split = "\t")
  handle <- data.frame(sapply(columns, function(i) sapply(handle, `[`, i)), stringsAsFactors = FALSE)
  if (length(col.names > 0)) {
    colnames(handle) <- col.names
  }
  return(handle)
}
