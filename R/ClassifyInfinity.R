
#' Infinity pipeline
#'
#' Wrapper function that performs all the recommended step. This includes
#' \describe{
#'   \item{Kcounter}{# Count Kmers and normalize data}
#'   \item{PredictionCaller}{Run prediction pipeline}
#'   \item{QualityControl}{Check Quality of the input data and classification results}
#'   \item{Quality_filter}{For sequences with any FLAG present set result Clade to LowQuality}
#' }
#'
#' @param inputFile string path relative to the working directory of the input file. Must be in fasta format.
#' @param outputFile string path relative to the working directory of the output file. Default = "results.csv"
#' @inheritParams QualityControl
#'
#' @return a comma-delimited file
#' @export
#'
#' @examples
#'
#' \dontrun{
#' file_path<-system.file("extdata","test_dataset.fasta",package="infinity")
#'
#' ClassifyInfinity(inputFile=file_path,model=FULL_HA)
#' }
ClassifyInfinity<-function(inputFile,
                           outputFile="results.csv",
                           model,
                           QC_value=0.6,
                           Length_value=0.5,
                           N_value=2){

  sequence<-ape::read.FASTA(inputFile,type = "DNA")

  # Count Kmers and normalize data

  NormalizedData <- Kcounter(SequenceData=sequence,model=model)
  #  Run prediction pipeline

  PredictedData <- PredictionCaller(NormalizedData=NormalizedData,model=model)

  #  Check Quality of the input data and classification results
  PredictedData <- QualityControl(PredictedData,
                                  model=model,
                                  QC_value=QC_value)
  # For sequences with any FLAG present set result Clade to LowQuality

  PredictedData <- Quality_filter(PredictedData)

  utils::write.csv2(PredictedData,outputFile)

}
