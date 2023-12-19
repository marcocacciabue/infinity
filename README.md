Marco Cacciabue, Débora N. Marcone

<!-- README.md is generated from README.Rmd. Please edit that file -->

# **INFINITy** <img src='man/figures/hex.png' style="float:right; height:200px;" /> a fast and accurate tool for classifying human influenza A and B virus sequences

<!-- badges: start -->

[![DOI](https://zenodo.org/badge/COMPLETE!!)](https://zenodo.org/badge/latestdoi/COMPLETE!!)
[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/marcocacciabue/infinity/workflows/R-CMD-check/badge.svg)](https://github.com/marcocacciabue/infinity/actions)
<!-- badges: end -->

If you wish to run the app without installation and directly on the web
go to one the following servers:

## [INFINITy web-application official server!](https://infinity.unlu.edu.ar/)

## [INFINITy web-application secondary server!](https://cacciabue.shinyapps.io/infinity2/)

If you find our app useful please consider citing: [Cacciabue et al
2023](https://doi.org/10.1111/irv.13096)

## :arrow_double_down: Installation

If you have a working R and Rstudio setup you can install the released
version of **INFINITy** from [GitHub](https://github.com/) with:

``` r
if (!require("remotes", quietly = TRUE))
  install.packages("remotes")
  
remotes::install_github("marcocacciabue/infinity")
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

This means that users that prefer working directly in an R console can
use some of the exported functions. The easiest way is to use the
wrapper funtion “ClassifyInfinity()”

``` r
#load the library
library(infinity)

# Indicate the file path to the fasta file to use.If your file is in your working directory you need to simply indicate the file name. In this case, we use a test file provided with the package itself. 

file_path<-system.file("extdata","test_dataset.fasta",package="infinity")

# Use the wrapper function. You can change the classification model and pass other arguments
ClassifyInfinity(inputFile=file_path,model=FULL_HA)

# This command run the whole pipeline and saves a file in the working directory a "Results.csv" by default. You can change the name file setting the "outputFile" parameter.
```

For a more detailed workflow the user can use the exported functions of
the package.

``` r
# First we indicate the location of the fasta file. In this case, we use a test file provided with the package itself.
file_path<-system.file("extdata","test_dataset.fasta",package="infinity")

# We load the sequences
sequence<-ape::read.FASTA(file_path,type = "DNA")

# We the count and normalize the k-mers
NormalizedData <- Kcounter(SequenceData=sequence,model=FULL_HA)

# We perform the classification
PredictedData <- PredictionCaller(NormalizedData=NormalizedData,model=FULL_HA)

# We add the quality FLAGs
PredictedData <- QualityControl(PredictedData,model=FULL_HA)

# We adjust the classification according to the FLAGs present for each sample:
PredictedData <- Quality_filter(PredictedData)

# The PredictedData dataframe contains the classifications

PredictedData
```

## :whale: Docker images available

### **INFINITy** as a shiny app in docker

Another way to run **INFINITy** as a shiny app is to use the docker
image. Follow these steps:

1.  If you don´t already have it, install docker:
    <https://www.docker.com/get-started>.

2.  Open a terminal and run the following:

``` bash
docker pull cacciabue/infinity:shiny
```

and wait for the image to download. You only have to run this command
the first time, or whenever you want to check for updates.

3.  Once the downloading is complete run the following:

``` bash
docker run -d --rm -p 3838:3838 cacciabue/infinity:shiny
```

4.  Finally, open your favorite browser and go to
    <http://localhost:3838/>
5.  The app should be up and running in your browser. Load the fasta
    file and press RUN.
6.  You can save a report using the corresponding button.

### **INFINITy** in a docker image with all dependecies allready installed

For more reproducibility a fully operational environment is available to
work directly in docker:

1.  If you don´t already have it, install docker:
    <https://www.docker.com/get-started>.

2.  Open a terminal, go to the directory where the fasta files are
    stored and run the following:

``` bash
docker pull cacciabue/infinity:cli
```

3.  Once the downloading is complete run the following:

``` bash
#for WINDOWS 
docker run --rm --volume %cd%:/nexus cacciabue/infinity:cli

#for unix/MAC
docker run -it --volume $(pwd):/nexus cacciabue/infinity:cli
```

4.  Now you can run

``` bash
setwd('nexus')

# Indicate the file path to the fasta file to use.If your file is in your working directory you need to simply indicate the file name. In this case, we use a test file provided with the package itself. 

file_path<-system.file("extdata","test_dataset.fasta",package="infinity")

# Use the wrapper function. You can change the classification model and pass other arguments
ClassifyInfinity(inputFile=file_path,model=FULL_HA)

# This command run the whole pipeline and saves a file in the working directory a "Results.csv" by default. You can change the name file setting the "outputFile" parameter.

# To exit the container just run

q()
```

5.  Alternatively you can perform step 3 and 4 in one command like this:

``` bash

#for WINDOWS 

docker run --rm --volume %cd%:/nexus cacciabue/infinity:cli R -e "setwd('nexus');library('infinity');ClassifyInfinity(inputFile='test_dataset.fasta',model=FULL_HA)"

#for unix/MAC

docker run --rm --volume $(pwd):/nexus cacciabue/infinity:cli R -e "setwd('nexus');library('infinity');ClassifyInfinity(inputFile='test_dataset.fasta',model=FULL_HA)"


# USER SHOULD CHANGE test_dataset.fasta for the correct file name
```
