
#' PredictionCaller
#'
#' Performs the prediction and computes probability values.
#'
#' @param NormalizedData A list of 3 vectors: normalized k-mer counts, genome length and contents of undefined bases.Produced by the´Kcounter´ function
#' @inheritParams Kcounter
#' @return Data.frame with the classification results and quality checks.
#' The output has the following properties:
#' * Each line corresponds to one sequence.
#' * `Label` is the name of the sequence.
#' * `Clade` is the corresponding prediction.
#' * `Probability` is the proportions of trees that agreed with the Clade result. values between 0 to 1.
#' * `Probability_QC` a logical value. If `TRUE` the sequence passed the quality filter for probability.
#' * `Length` Sequence length.
#' * `Length_QC` a logical value. If `TRUE` the sequence passed the quality filter for length.
#' * `N` proportions of undefined bases in the sequence. The lower the better.
#' * `N_QC` a logical value. If `TRUE` the sequence passed the quality filter for undefined bases.
#'
#' @export
#' @importFrom ranger predictions
#' @examples
#'
#'
#'
#' file_path<-system.file("extdata","test_dataset.fasta",package="infinity")
#'
#' sequence<-ape::read.FASTA(file_path,type = "DNA")
#'
#' NormalizedData <- Kcounter(SequenceData=sequence,model=FULL_HA)
#'
#' PredictedData <- PredictionCaller(NormalizedData=NormalizedData,model=FULL_HA)
#'

PredictionCaller<-function(NormalizedData,
                           model){

   if (is.null(NormalizedData) | missing(NormalizedData)){
    stop("'NormalizedData' must be indicated")
  }

  ModelControl(model)

  calling<-predict(model,
                               NormalizedData$DataCount)
  #Run the predict method from de Ranger package, retaining the classification result from each tree in the model (to calculate a probability value for each classification)
  calling_all<-predict(model,
                                   NormalizedData$DataCount,
                                   predict.all = TRUE)
  probability <- rep(0, length(calling_all$predictions[,1]))

  for (i in 1:length(calling_all$predictions[,1])) {
    #extract predictions for each SequenceData sample in temp vector,
    #count the number of correct predictions and divide by number of trees to get a probability.
    temp<-calling_all$predictions[i,]
    probability[i] <- sum(temp==which(model$forest$levels==calling$predictions[i]))/model$num.trees

  }


  # QualityList<-QualityControl(n_length=NormalizedData$n_length,
  #                          genome_length=NormalizedData$genome_length,
  #                          probability,
  #                          model)
  samples<-rep(0,length(row.names(NormalizedData$DataCount)))
  return(data.frame(Label= row.names(NormalizedData$DataCount),
             Clade=calling$prediction,
             Probability=probability,
             Length=NormalizedData$genome_length,
             Length_QC=samples,
             N=NormalizedData$n_length,
             N_QC=samples,
             Probability_QC=samples))
  # return(data.frame(Label= row.names(NormalizedData$DataCount),
  #                   Clade=calling$prediction,
  #                   Probability=probability,
  #                   Length=NormalizedData$genome_length,
  #                   Length_QC=QualityList$Length_QC,
  #                   N=NormalizedData$n_length,
  #                   N_QC=QualityList$n_QC,
  #                   Probability_QC=QualityList$Probability_QC))
}



#' QualityControl
#'
#' @param data data.frame obtained with [PredictionCaller()]
#' @param QC_value numeric value from 0 to 1. (default = 0.6)
#' @inheritParams Kcounter
#' @return A list with three logical vectors. In each case TRUE means pass.
#'
#' @export
#'
#' @examples
#'
#' file_path<-system.file("extdata","test_dataset.fasta",package="infinity")
#'
#' sequence<-ape::read.FASTA(file_path,type = "DNA")
#'
#' NormalizedData <- Kcounter(SequenceData=sequence,model=FULL_HA)
#'
#' PredictedData <- PredictionCaller(NormalizedData=NormalizedData,model=FULL_HA)
#'
#' QualityControl(PredictedData,model=FULL_HA)
#'
#'
QualityControl<-function(data,
                         QC_value=0.6,
                         model){
  ModelControl(model)

  data$N_QC<-(data$N<2)

  if ("Flu"==model$info){
    data$Length_QC<-(data$Length>1600)&(data$Length<2000)
  }
  if ("Flu_Ha1"==model$info){
    data$Length_QC<-(data$Length>900)&(data$Length<1100)
  }
  data$Probability_QC<-data$Probability>QC_value

  return(data)

}




#' Stringent_filter
#'
#' Change Clade definition to unknown in samples with a probability score
#' below a threshold
#'
#' @inheritParams QualityControl
#'
#' @return data.frame
#' @export
#'
#' @examples
#'
#' file_path<-system.file("extdata","test_dataset.fasta",package="infinity")
#'
#' sequence<-ape::read.FASTA(file_path,type = "DNA")
#'
#' NormalizedData <- Kcounter(SequenceData=sequence,model=FULL_HA)
#'
#' PredictedData <- PredictionCaller(NormalizedData=NormalizedData,model=FULL_HA)
#'
#' PredictedData <- QualityControl(PredictedData,model=FULL_HA)
#'
#' PredictedData <- Stringent_filter(PredictedData)
#'
Stringent_filter<- function(data,
                            QC_value=0.2){

      filter<-data$Probability<QC_value
      data$Clade <- as.character(data$Clade)
      data$Clade[filter]<-"unknown"
  return(data)
}




#' Quality_filter
#'
#' Change Clade definition to LowQuality in samples with either a FLAg from genome length or
#' proportion of N bases.
#'
#' @inheritParams QualityControl
#'
#' @return data.frame
#' @export
#'
#' @examples
#'
#' file_path<-system.file("extdata","test_dataset.fasta",package="infinity")
#'
#' sequence<-ape::read.FASTA(file_path,type = "DNA")
#'
#' NormalizedData <- Kcounter(SequenceData=sequence,model=FULL_HA)
#'
#' PredictedData <- PredictionCaller(NormalizedData=NormalizedData,model=FULL_HA)
#'
#' PredictedData <- QualityControl(PredictedData,model=FULL_HA)
#'
#' PredictedData <- Quality_filter(PredictedData)
#'
Quality_filter<- function(data){

  filter<-!(data$Length_QC&data$N_QC)
  data$Clade <- as.character(data$Clade)
  data$Clade[filter]<-"LowQuality"
  return(data)
}


