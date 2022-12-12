#' Random forest classification model based on full length HA sequence
#'
#' This a classification model (created with the ranger package) to use with the infinity package
#' The model includes:
#'
#' @format A list with 18 elements (modified from a Object of class `ranger`):
#' \describe{
#'   \item{predictions}{training dataset predictions}
#'   \item{num.trees}{Number of decision trees (ussually 1000)}
#'   \item{num.independent.variables}{Number of independent variables}
#'   \item{mtry}{Value of mtry used}
#'   \item{min.node.size}{Value of minimal node size used.}
#'   \item{prediction.error}{Overall out of bag prediction error.}
#'   \item{forest}{Saved forest}
#'   \item{confusion.matrix}{Contingency table for classes and predictions based on out of bag samples }
#'   \item{splitrule}{tSplit rule used for training}
#'   \item{num.random.splits}{Number of random splits}
#'   \item{treetype}{Type of forest/tree}
#'   \item{call}{Function call}
#'   \item{importance.mode}{Importance mode used}
#'   \item{num.samples}{Number of samples}
#'   \item{kmer}{k-mer size used for preprocessing}
#'   \item{info}{extra information of the classification model (optional)}
#'   \item{date}{date of model creation}
#' }
"FULL_HA"

#' Random forest classification model based on partial length HA1 sequence
#'
#' This a classification model (created with the ranger package) to use with the infinity package
#' The model includes:
#'
#' @format A list with 18 elements (modified from a Object of class `ranger`):
#' \describe{
#'   \item{predictions}{training dataset predictions}
#'   \item{num.trees}{Number of decision trees (ussually 1000)}
#'   \item{num.independent.variables}{Number of independent variables}
#'   \item{mtry}{Value of mtry used}
#'   \item{min.node.size}{Value of minimal node size used.}
#'   \item{prediction.error}{Overall out of bag prediction error.}
#'   \item{forest}{Saved forest}
#'   \item{confusion.matrix}{Contingency table for classes and predictions based on out of bag samples }
#'   \item{splitrule}{tSplit rule used for training}
#'   \item{num.random.splits}{Number of random splits}
#'   \item{treetype}{Type of forest/tree}
#'   \item{call}{Function call}
#'   \item{importance.mode}{Importance mode used}
#'   \item{num.samples}{Number of samples}
#'   \item{kmer}{k-mer size used for preprocessing}
#'   \item{info}{extra information of the classification model (optional)}
#'   \item{date}{date of model creation}
#' }
"HA1"
