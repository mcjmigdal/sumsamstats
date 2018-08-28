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
#' Sections names are: SN (summary numbers), FFQ (first fragment qualities), LFQ (last fragment qualities),
#' GCF (GC Content of first fragments), GCL (GC content of last fragments), GCC (ACGT content per cycle),
#' IS (insert size), RL (read lengths), ID (indel distribution), IC (indels per cycle), COV (coverage distribution),
#' GCD (GC-depth)
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
    toExtract <- list(
                      section = list(
                                     "SN", # Summary Numbers
                                     "FFQ", # First Fragment Qualitites
                                     "LFQ", # Last Fragment Qualitites
                                     "GCF", # GC Content of First fragments
                                     "GCL", # GC Content of Last fragments
                                     "GCC", # ACGT content per cycle
                                     "IS", # Insert Size
                                     "RL", # Read lengths
                                     "ID", # Indel distribution
                                     "IC", # Indels per cycle
                                     "COV", # Coverage distribution
                                     "GCD" # GC-depth
                                     ),
                      columns = list(
                                     c(2, 3),
                                     2:43,
                                     2:43,
                                     c(2, 3),
                                     c(2, 3),
                                     2:8,
                                     c(2, 3),
                                     c(2, 3),
                                     c(2, 3, 4),
                                     c(2, 3, 4, 5, 6),
                                     c(3, 4), # TODO review if all informative values are greped
                                     c(2, 3, 4, 5, 6, 7, 8)
                                     ),
                      col.names = list(
                                       c("description", "value"),
                                       c("cycle", paste0("Qual", 1:41)),
                                       c("cycle", paste0("Qual", 1:41)),
                                       c("GC", "count"),
                                       c("GC", "count"),
                                       c("cycle", "A", "C", "G", "T", "N", "O"),
                                       c("insert_size", "pairs_total"),
                                       c("read_length", "count"),
                                       c("length", "number_of_insertions", "number_of_deletions"),
                                       c(
                                         "cycle",
                                         "number_of_insertions_fwd",
                                         "number_of_insertions_rwd",
                                         "number_of_deletions_fwd",
                                         "number_of_deletions_rwd"
                                         ),
                                       c("coverage", "bases"),
                                       c("GC", "unique_sequence_percentiles", "10th", "25th", "50th", "75th", "90th")
                                       )
                      )
    for (i in 1:12) {
        stats[[toExtract$section[[i]]]] <- .grepData(
                                                     inputFile,
                                                     toExtract$section[[i]],
                                                     columns = toExtract$columns[[i]],
                                                     col.names = toExtract$col.names[[i]]
                                                     )
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
  if (! section %in% c("SN", "FFQ", "LFQ", "GCF", "GCL", "GCC", "IS", "RL", "ID", "IC", "COV", "GCD")) { # TODO move it to readSamStats
    stop(paste0("Parsing '", section, "' is not supported!"))
  }
  section <- paste("^", section, sep = "")
  handle <- strsplit(input[grep(pattern = section, input)], split = "\t")
  handle <- data.frame(sapply(columns, function(i) sapply(handle, `[`, i)), stringsAsFactors = FALSE)
  if (length(col.names > 0)) {
    colnames(handle) <- col.names
  }
  return(handle)
}
