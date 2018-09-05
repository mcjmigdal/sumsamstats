#' Run ATAC-seq quality control application
#'
#' Launch Shiny application that allows to quickly insepect multiple ATAC-seq
#' libraries and check some of the basic quality controls.
#'
#' Some more detailed description etc.
#'
#' @examples
#' sumsamstats::runExample()
#'
#' @export
runATACapp <- function() {
    appDir <- system.file("sumsamstats", package = "sumsamstats")
    if (appDir == "") {
        stop("Could not find example directory. Try re-installing 'sumsamstats'.", call. = FALSE)
    }

    shiny::runApp(appDir, display.mode = "normal")
}
