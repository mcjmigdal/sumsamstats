#' Run ATAC-seq quality control application
#'
#' Launch Shiny application that allows to quickly insepect multiple ATAC-seq
#' libraries and check some of the basic quality controls.
#'
#' @examples
#' sumsamstats::runATACapp()
#'
#' @export
runATACapp <- function() {
    appDir <- system.file("sumsamstats", package = "sumsamstats")
    if (appDir == "") {
        stop("Could not find package sumsamstats. Try re-installing 'sumsamstats'.", call. = FALSE)
    }
    
    shiny::runApp(appDir, display.mode = "normal")
}
