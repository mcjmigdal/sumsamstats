#' Parse samtools stat output
#'
#' readSamtoolsStats parses output of samtools stat making it easy to
#' work with it in R.
#'
#' @param file the name of the file which the data are to be read from. File must be
#' of type \code{character}, providing path to input file. If it does not provide an
#' absolute path(s), the file name is relative to the current working directory, \code{getwd()}.
#'
#' @param section A character vector of patterns to extract from the report. Each section of samtools stats report is uniquley
#' labeled, for example Summary Numbers are labeled as SN. By default all sections are read.
#'
#' @return list of data frames holding data from different parts of \code{samtools stat} output.
#' Sections names are: SN (summary numbers), FFQ (first fragment qualities), LFQ (last fragment qualities),
#' GCF (GC Content of first fragments), GCL (GC content of last fragments), GCC (ACGT content per cycle),
#' IS (insert size), RL (read lengths), ID (indel distribution), IC (indels per cycle), COV (coverage distribution),
#' GCD (GC-depth)
#'
#' @examples
#' readSamtoolsStats(file = system.file('extdata', 'sample1', package = 'sumsamstats'))
#'
#' @export
readSamtoolsStats <- function(file, section = c("SN", "FFQ", "LFQ", "GCF", "GCL", "GCC", "IS", "RL", "ID", "IC", "COV", "GCD")) {
    if (!is.character(file)) {
        stop("File argument must be of class character!\n")
    }
    if (!file.exists(file)) {
        stop(paste0("File '", file, "' doesn't exists!\n"))
    }
    if (all(!section %in% c("SN", "FFQ", "LFQ", "GCF", "GCL", "GCC", "IS", "RL", "ID", "IC", "COV", "GCD"))) {
        stop(paste0("Parsing '", section, "' is not supported!"))
    }

    grepTable <- list(
      SN = list(
        columns = c(2, 3),
        col.names = c("description", "value")
        ),
      FFQ = list(
        columns = 2:43,
        col.names = c("cycle", paste0("Qual", 1:41))
        ),
      LFQ = list(
        columns = 2:43,
        col.names = c("cycle", paste0("Qual", 1:41))
        ),
      GCF = list(
        columns = c(2, 3),
        col.names = c("GC", "count")
        ),
      GCL = list(
        columns = c(2, 3),
        col.names = c("GC", "count")
        ),
      GCC = list(
        columns = 2:8,
        col.names = c("cycle", "A", "C", "G", "T", "N", "O")
        ),
      IS = list(
        columns = c(2, 3),
        col.names = c("insert_size", "pairs_total")
        ),
      RL = list(
        columns = c(2, 3),
        col.names = c("read_length", "count")
        ),
      ID = list(
        columns = c(2, 3, 4),
        col.names = c("length", "number_of_insertions", "number_of_deletions")
        ),
      IC = list(
        columns = c(2, 3, 4, 5, 6),
        col.names = c("cycle", "number_of_insertions_fwd", "number_of_insertions_rwd",
                      "number_of_deletions_fwd", "number_of_deletions_rwd")
        ),
      COV = list(
        columns = c(3, 4),
        col.names = c("coverage", "bases")
        ),
      GCD = list(
        columns = c(2, 3, 4, 5, 6, 7, 8),
        col.names = c("GC", "unique_sequence_percentiles", "10th", "25th", "50th", "75th", "90th")
        )
      )

    stats <- list()
    inputFile <- readLines(file)
    for (i in 1:length(section)) {
        stats[[section[i]]] <- .grepData(inputFile, section[i], columns = grepTable[[section[i]]]$columns, col.names = grepTable[[section[i]]]$col.names)
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
#' @param columns A integer vector containing numbers of columns to extract from specified section of samtools
#' stats report.
#'
#' @param section Pattern to extract from the report. Each section of samtools stats report is uniquley
#' labeled, for example Summary Numbers are labeled as SN.
#'
#' @param col.names A character vector containing names of extracted columns. Optional.
#'
#' @return data frame holding data from selected section of \code{samtools stat} output.
#'
#' @examples
#' file <- system.file('extdata', 'sample1', package = 'sumsamstats')
#' inputFile <- readLines(file)
#' .grepData(input=inputFile, section='SN', columns=c(2,3), col.names=c('description', 'value'))
#'
.grepData <- function(input, section, columns, col.names = "") {
    section <- paste("^", section, sep = "")
    handle <- strsplit(input[grep(pattern = section, input)], split = "\t")
    if (length(handle) == 0) {
        stop("Could not find pattern '", section, "'!")
    }
    handle <- data.frame(vapply(columns, function(i) {
        vapply(handle, `[`, i, FUN.VALUE = character(1))
    }, FUN.VALUE = character(length(handle))), stringsAsFactors = FALSE)
    if (length(col.names > 0)) {
        colnames(handle) <- col.names
    }
    return(handle)
}
