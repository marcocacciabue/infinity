


#' Run INFINITy shiny app
#'
#' Deploys a server that runs the INFINITy app locally
#'
#'
#' @return a shiny app
#' @export
#'
#' @examples
#' \dontrun{
#' runShinyApp()
#' }
#'

runShinyApp <- function() {
  # # locate all the shiny app examples that exist
  # validExamples <- list.files(system.file("myapp", package = "infinity"))
  #
  # validExamplesMsg <-
  #   paste0(
  #     "Valid examples are: '",
  #     paste(validExamples, collapse = "', '"),
  #     "'")

  # # if an invalid example is given, throw an error
  # if (missing(AppName) || !nzchar(AppName)) {
  #   stop(
  #     'Please run .\n',
  #     call. = FALSE)
  # }

  # find and launch the app
  appDir <- system.file("myapp", "app.R", package = "infinity")
  shiny::runApp(appDir, display.mode = "normal")
}
