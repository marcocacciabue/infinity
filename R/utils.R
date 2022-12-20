

#' ModelControl
#' Utility function to check the classification model object
#'
#' @param model  random forest classification model. Must be FULL_HA or HA1. See [FULL_HA] and [HA1].
#'
#' @return warnings
#'
#' @export
#'
#' @examples
#' ModelControl(FULL_HA)
ModelControl<- function(model){

  if (is.null(model)){
    stop("Model argument must be indicated and cannot be null. Try model=FULL_HA or model=HA1")
  }

  if (methods::is(model)!="ranger"){
    stop("Model must be a ranger object. Try model=FULL_HA or model=HA1")
  }

  if (!"info" %in% names(model)){
    stop("Model must include the info object. Try model=FULL_HA or model=HA1")
  }
  if (!"date" %in% names(model)){
    stop("Model must include the date object. Try model=FULL_HA or model=HA1")
  }


}
