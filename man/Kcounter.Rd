% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CounterNormalizer.R
\name{Kcounter}
\alias{Kcounter}
\title{Kcounter}
\usage{
Kcounter(SequenceData, model)
}
\arguments{
\item{SequenceData}{A list of DNA sequences. Object must be created with the \code{ape} package. See example.}

\item{model}{A random forest classification model. Must be FULL_HA or HA1. See \link{FULL_HA} and \link{HA1}.}
}
\value{
A list of 3 vectors: normalized k-mer counts, genome length and contents of undefined bases.
}
\description{
Counts k-mers of the size required by the input model and normalize the data regarding genome size.
}
\examples{

file_path<-system.file("extdata","test_dataset.fasta",package="infinity")

sequence<-ape::read.FASTA(file_path,type = "DNA")

NormalizedData<-Kcounter(SequenceData=sequence,model=FULL_HA)
}
