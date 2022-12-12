
#' PredictionCaller
#'
#' Performs the prediction and computes probability values. It also
#'
#' @param NormalizeList
#' @param model
#'
#' @return
#' @export
#'
#' @examples
PredictionCaller<-function(NormalizeList,
                           model){

  calling<-predict(model,
                               NormalizeList$SequenceData_count)
  #Run the predict method from de Ranger package, retaining the classification result from each tree in the model (to calculate a probability value for each classification)
  calling_all<-predict(model,
                                   NormalizeList$SequenceData_count,
                                   predict.all = TRUE)
  probability <- rep(0, length(calling_all$predictions[,1]))

  for (i in 1:length(calling_all$predictions[,1])) {
    #extract predictions for each SequenceData sample in temp vector,
    #count the number of correct predictions and divide by number of trees to get a probability.
    temp<-calling_all$predictions[i,]
    probability[i] <- sum(temp==which(model$forest$levels==calling$predictions[i]))/model$num.trees

  }


  QualityList<-QualityControl(n_length=NormalizeList$n_length,
                           genome_length=NormalizeList$genome_length,
                           probability,
                           model)

  return(data.frame(Label= row.names(NormalizeList$SequenceData_count),
             Clade=calling$prediction,
             Probability=probability,
             Length=NormalizeList$genome_length,
             Length_QC=QualityList$Length_QC,
             N=NormalizeList$n_length,
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
#' @examples
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



