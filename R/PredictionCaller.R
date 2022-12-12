
#' PredictionCaller
#'
#' Performs the prediction and computes probability values. It also
#' runs ´QualityControl()´ function on all samples.
#'
#' @param NormalizedData A list of 3 vectors: normalized k-mer counts, genome length and contents of undefined bases.Produced by the´CounterNormalizer´ function
#' @inheritParams model
#'
#' @return
#' @export
#'
#' @examples
#'
#' file_path<-system.file("extdata","test_dataset.fasta",package="infinity")
#'
#' SequenceData<-ape::read.FASTA(file_path,type = "DNA")
#'
#' NormalizedData<-CounterNormalizer(SequenceData,FULL_HA)
#'
#' PredictedData <-  infinity::PredictionCaller(NormalizedData,infinity::FULL_HA)
#'

PredictionCaller<-function(NormalizedData,
                           model){

  calling<-predict(model,
                               NormalizedData$SequenceData_count)
  #Run the predict method from de Ranger package, retaining the classification result from each tree in the model (to calculate a probability value for each classification)
  calling_all<-predict(model,
                                   NormalizedData$SequenceData_count,
                                   predict.all = TRUE)
  probability <- rep(0, length(calling_all$predictions[,1]))

  for (i in 1:length(calling_all$predictions[,1])) {
    #extract predictions for each SequenceData sample in temp vector,
    #count the number of correct predictions and divide by number of trees to get a probability.
    temp<-calling_all$predictions[i,]
    probability[i] <- sum(temp==which(model$forest$levels==calling$predictions[i]))/model$num.trees

  }


  QualityList<-QualityControl(n_length=NormalizedData$n_length,
                           genome_length=NormalizedData$genome_length,
                           probability,
                           model)

  return(data.frame(Label= row.names(NormalizedData$SequenceData_count),
             Clade=calling$prediction,
             Probability=probability,
             Length=NormalizedData$genome_length,
             Length_QC=QualityList$Length_QC,
             N=NormalizedData$n_length,
             N_QC=QualityList$n_QC,
             Probability_QC=QualityList$Probability_QC))
}



#' QualityControl
#'
#' @param n_length
#' @param genome_length
#' @param probability
#' @param model
#' @return
#'
#'
QualityControl<-function(n_length,
         genome_length,
         probability,
         model){

  n_QC<-(n_length<2)

  if (model$info=="Flu"){
    Length_QC<-(genome_length>1600)&(genome_length<2000)
  }
  if (model$info=="HA1"){
    Length_QC<-(genome_length>900)&(genome_length<1100)
  }
  Probability_QC<-probability>0.6

  return(list(Probability_QC=Probability_QC,
              Length_QC=Length_QC,
              n_QC=n_QC))

}



