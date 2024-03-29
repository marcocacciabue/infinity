% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PredictionCaller.R
\name{PredictionCaller}
\alias{PredictionCaller}
\title{PredictionCaller}
\usage{
PredictionCaller(NormalizedData, model, QC_unknown = 0.2)
}
\arguments{
\item{NormalizedData}{A list of 3 elements: normalized k-mer counts, genome length and contents of undefined bases.Produced by the \code{\link[=Kcounter]{Kcounter()}} function}

\item{model}{A random forest classification model. Must be FULL_HA or HA1. See \link{FULL_HA} and \link{HA1}.}

\item{QC_unknown}{numeric value from 0 to 1. Stringent filter, do not classify below this probability score (default = 0.2)}
}
\value{
Data.frame with the classification results and quality checks.
The output has the following properties:
\itemize{
\item Each row corresponds to one sample sequence.
\item \code{Label} is the name of the sequence.
\item \code{Clade} is the corresponding prediction.
\item \code{Probability} is the proportions of trees that agreed with the Clade result. Values between 0 to 1.
\item \code{Probability_QC} a logical value. If \code{TRUE} the sequence passed the quality filter for probability. Run \code{\link[=QualityControl]{QualityControl()}} to fill this column.
\item \code{Length} Sequence length.
\item \code{Length_QC} a logical value. If \code{TRUE} the sequence passed the quality filter for length.Run \code{\link[=QualityControl]{QualityControl()}} to fill this column
\item \code{N} proportions of undefined bases in the sequence. The lower the better.
\item \code{N_QC} a logical value. If \code{TRUE} the sequence passed the quality filter for undefined bases. Run \code{\link[=QualityControl]{QualityControl()}} to fill this column
}
}
\description{
Performs the prediction and computes probability values.
}
\examples{



file_path<-system.file("extdata","test_dataset.fasta",package="infinity")

sequence<-ape::read.FASTA(file_path,type = "DNA")

NormalizedData <- Kcounter(SequenceData=sequence,model=FULL_HA)

PredictedData <- PredictionCaller(NormalizedData=NormalizedData,model=FULL_HA)

}
