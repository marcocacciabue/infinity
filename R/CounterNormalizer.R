
#' Kcounter
#'
#' Counts k-mers of the size required by the input model and normalize the data regarding genome size.
#'
#'
#' @param SequenceData A list of DNA sequences. Object must be created with the `ape` package. See example.
#' @param model A random forest classification model. Must be FULL_HA or HA1. See [FULL_HA] and [HA1].
#'
#' @return A list of 3 vectors: normalized k-mer counts, genome length and contents of undefined bases.
#'
#' @export
#'
#' @examples
#'
#' file_path<-system.file("extdata","test_dataset.fasta",package="infinity")
#'
#' sequence<-ape::read.FASTA(file_path,type = "DNA")
#'
#' NormalizedData<-Kcounter(SequenceData=sequence,model=FULL_HA)

Kcounter<-function(SequenceData,
                    model){
  ModelControl(model)
  DataCount<-kmer::kcount(SequenceData , k=model$kmer)
  genome_length<-0
  n_length<-0
  for(i in 1:length(DataCount[,1])){

    k<-SequenceData[i]
    k<-as.matrix(k)
    DataCount[i,]<- DataCount[i,]*model$kmer/(length(k))
    genome_length[i]<-length(k)
    n_length[i]<-round(100*ape::base.freq(k,all = TRUE)[15],2)
  }
 return(list(DataCount=DataCount,
             genome_length=genome_length,
             n_length=n_length))
}



