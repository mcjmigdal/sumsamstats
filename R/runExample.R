runExample <- function() {
    appDir <- "/home/mmigdal/Documents/sumsamstats/inst/sumsamstats"  #it must find path by itself
    if (appDir == "") {
        stop("Could not find example directory. Try re-installing 'sumsamstats'.", call. = FALSE)
    }
    
    shiny::runApp(appDir, display.mode = "normal")
}
