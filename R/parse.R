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
readSamtoolsStats <- function(file, ...) {
    if (!is.character(file)) {
        stop("File argument must be of class character!\n")
    }
    if (!file.exists(file)) {
        stop(paste0("File '", file, "' doesn't exists!\n"))
    }

    getData <- function(input, pattern, columns, col.names = "") {
        handle <- strsplit(inputFile[grep(pattern = pattern, input)], split = "\t")
        handle <- data.frame(sapply(columns, function(i) sapply(handle, `[`, i)), stringsAsFactors = FALSE)
        if (length(col.names > 0)) {
            colnames(handle) <- col.names
        }
        return(handle)
    }

    stats <- list()
    inputFile <- readLines(file)
    toExtract <- list(pattern = list("SN", "IS"), columns = list(c(2, 3), c(2, 3)), col.names = list(c("description", "value"), c("insert_size", "pairs_total")))

    for (i in 1:2) {
        stats[[toExtract$pattern[[i]]]] <- getData(inputFile, paste("^", toExtract$pattern[[i]], sep = ""), columns = toExtract$columns[[i]], col.names = toExtract$col.names[[i]])
    }
    return(stats)
}
