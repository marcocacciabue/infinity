# library("ranger")
library("infinity")


file_path<-system.file("extdata","test_dataset.fasta",package="infinity")

sequence<-ape::read.FASTA(file_path,type = "DNA")

NormalizedData<-Kcounter(SequenceData=sequence,model=FULL_HA)

calling_null<-ranger::predictions(FULL_HA)


PredictedData <- PredictionCaller(NormalizedData=NormalizedData,model=FULL_HA)


test_that("A dataframe is produced with the corresponding results ", {
  expect_true(is.data.frame(PredictedData))
  expect_true(length(colnames(PredictedData))==8)
  expect_true("Label" %in% colnames(PredictedData))

})

test_that("The number of results in dataframe is equal to number of test sequences", {
  expect_true(length(sequence)==length(PredictedData$Label))

})



NormalizedData<-Kcounter(SequenceData=sequence,model=HA1)

calling_null<-ranger::predictions(HA1)


PredictedData <- PredictionCaller(NormalizedData=NormalizedData,model=HA1)


test_that("A dataframe is produced with the corresponding results ", {
  expect_true(is.data.frame(PredictedData))
  expect_true(length(colnames(PredictedData))==8)
  expect_true("Label" %in% colnames(PredictedData))

})

test_that("The number of results in dataframe is equal to number of test sequences", {
  expect_true(length(sequence)==length(PredictedData$Label))

})

