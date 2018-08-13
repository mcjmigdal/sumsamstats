runExample <- function() {
  appDir <- "/home/mmigdal/Documents/site_things/sumsamstats/inst/sumsamstats"
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing 'sumsamstats'.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
