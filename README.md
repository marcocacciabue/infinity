Marco Cacciabue, Débora N. Marcone

<!-- README.md is generated from README.Rmd. Please edit that file -->

# **INFINITy** <img src='man/figures/hex.png' align="right" height="200" /> a fast and accurate tool for classifying human influenza A and B virus sequences

<!-- badges: start -->

[![DOI](https://zenodo.org/badge/COMPLETE!!)](https://zenodo.org/badge/latestdoi/COMPLETE!!)
[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/marcocacciabue/infinity/workflows/R-CMD-check/badge.svg)](https://github.com/marcocacciabue/infinity/actions)
<!-- badges: end -->

If you wish to run the app without installation and directly on the web
go to one the following servers:

## [INFINITy web-application official server!](https://infinity.unlu.edu.ar/)

## [INFINITy web-application secondary server!](https://cacciabue.shinyapps.io/infinity/)

If you find our app useful please consider citing: [Cacciabue et al
2022](https://www.biorxiv.org/)

## :arrow\_double\_down: Installation

If you have a working R and Rstudio setup you can install the released
version of **INFINITy** from [GitHub](https://github.com/) with:

``` r
if (!require("devtools", quietly = TRUE))
  install.packages("devtools")
  
devtools::install_github("marcocacciabue/infinity")
```

This could take several minutes depending on your system and
installation. Only the first time it runs.

Alternatively, you can download the repository as a .zip file and
install it manually with Rstudio.

## :computer: Deploying **INFINITy**

To start the app simply run the following command:

``` r
infinity::runShinyApp()
```

:+1: You are ready to classify your data.

## **INFINITy** is an R package

This means that users that prefer working with a command-line interface
can use some of the exported functions. We provide some basic usage of
the functions:

``` r
# First we indicate the location of the fasta file. In this case, we use a test file provided with the package itself.
file_path<-system.file("extdata","test_dataset.fasta",package="infinity")

# We load the sequences
sequence<-ape::read.FASTA(file_path,type = "DNA")

# We the count and normalize the k-mers
NormalizedData <- Kcounter(SequenceData=sequence,model=FULL_HA)

# We perform the classification
PredictedData <- PredictionCaller(NormalizedData=NormalizedData,model=FULL_HA)

# The PredictedData dataframe contains the classifications and the control flags.

PredictedData
```

## :whale: Docker image available

Another way to run **INFINITy** as a shiny app is to use the docker
image. Follow these steps:

1.  If you don´t already have it, install docker:
    <https://www.docker.com/get-started>.
2.  Open a terminal and run the following:

``` bash
docker pull cacciabue/infinity:developing
```

and wait for the image to download. You only have to run this command
the first time, or whenever you want to check for updates.

3.  Once the downloading is complete run the following:

``` bash
docker run -d --rm -p 3838:3838 cacciabue/infinity:developing
```

4.  Finally, open your favorite browser and go to
    <http://localhost:3838/>
5.  The app should be up and running in your browser. Load the fasta
    file and press RUN.
6.  You can save a report using the corresponding button.
