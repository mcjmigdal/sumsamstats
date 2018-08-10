readSamtoolsStats <- function(file, ...) {
  if (!is.character(file)) {
    stop("File argument must me of class character!\n")
  }
  if (!file.exists(file)) {
    stop(paste0("File '", file, "' doesn't exists!\n"))
  }

  getData <- function(input, pattern, columns, col.names = "") {
    handle <- strsplit(inputFile[grep(pattern = pattern, input)],
                split = "\t")
    handle <- data.frame(sapply(columns, function(i) sapply(handle,
                `[`, i)), stringsAsFactors = FALSE)
    if (length(col.names > 0)) {
      colnames(handle) <- col.names
    }
    return(handle)
  }

  stats <- list()
  inputFile <- readLines(file)
  toExtract <- list(pattern = list("SN", "IS"),
                    columns = list(c(2, 3), c(2, 3)),
                    col.names = list(c("description", "value"),
                                      c("insert_size", "pairs_total"))
                    )

  for (i in 1:2) {
    stats[[toExtract$pattern[[i]]]] <- getData(inputFile, paste("^",
        toExtract$pattern[[i]], sep = ""), columns = toExtract$columns[[i]],
        col.names = toExtract$col.names[[i]])
  }
  return(stats)
}
