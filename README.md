Marco Cacciabue, Debora Marcone

<!-- README.md is generated from README.Rmd. Please edit that file -->

# **INFINITy** <img src='man/figures/logo.jpg' align="right" height="139" /> a fast and accurate tool for classifying human influenza A and B virus sequences

<!-- badges: start -->

[![DOI](https://zenodo.org/badge/COMPLETE!!)](https://zenodo.org/badge/latestdoi/COMPLETE!!)
[![](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
<!-- badges: end -->

### [INFINITy web-application!](https://cacciabue.shinyapps.io/infinit/)

in production [Cacciabue et al 2022](https://www.biorxiv.org/)

## :arrow\_double\_down: Installation

If you have a working R and Rstudio setup you you can install the
released version of **INFINITy** from [GitHub](https://github.com/)
with:

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
infinity::runExample("app.R")
```

:+1: You are ready to classify your data.

## :whale: Docker image available

Another way to run **INFINITy** is to use the docker image. Follow these
steps:

1.  If you don´t already have it, install docker:
    <https://www.docker.com/get-started>.
2.  Open a terminal and run the following:

``` bash
docker pull cacciabue/infinity:latest
```

and wait for the image to download. You only have to run this command
the first time, or whenever you want to check for updates. 3. Once the
downloading is complete run the following:

``` bash
docker run -d --rm -p 3838:3838 cacciabue/infinity:latest
```

4.  Finally, open your favorite browser and go to
    <http://localhost:3838/>
5.  The app should be up and running in your browser. Load the fasta
    file and press RUN.
6.  You can save a report using the corresponding button.
