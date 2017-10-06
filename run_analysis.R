library(reshape2)

#
# This script will create a Tidy Dataset for the "UCI HAR Dataset" from:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
# The Tidy Dataset will be saved on your workdirectory with
# the name "tidyData.txt". Load the data with:
# read.table("tidyData.txt", header=TRUE)
#

# Downloads and unzips the data if not in the working directory
downloadData <- function() {
  zipName <- "data.zip"
  if (!file.exists(zipName)) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = zipName)
  }
  
  unzip(zipName)
}

# Load the feature names from the "features.txt" fie, selects only the "mean" and "std" features
# and clean the names a little (removes parentheses)
loadFeaturesTable <- function(rootPath) {
  featuresFilePath <- file.path(rootPath, "features.txt")
  table <- read.table(featuresFilePath, colClasses=c("integer","character"))
  featuresSel <- grepl("mean\\(\\)", table$V2) | grepl("std\\(\\)", table$V2)
  table <- table[featuresSel, ]
  table$V2 <- gsub("\\(\\)", "", table$V2)
  table
}

# Load the "<dataType>/[subject_|X_|y_]<dataType>.txt" files, then filter
# the features using the "featuresTable" and then combine the contents of
# all the files into a single table.
#
# Each row contains a test case and the columns are layout as:
# 1:   subject         # stores the subjects id as an integer
# 2-n: named features  # stores the features for this particular test.
#                      #   Note that these are the same features passed
#                      #   with the "featuresTable" parameter. 
# n+1: y               # the classification result (activity) as a
#                      #   character string. See list below.
#
# The list of the six activies are as follow:
# "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS,
# "SITTING", "STANDING" and "LAYING"
loadData <- function(rootPath, featuresTable, dataType) {
  subjectFilePath <- file.path(rootPath, dataType, paste("subject_", dataType, ".txt", sep=""))
  subjectTable <- read.table(subjectFilePath, colClasses=c("integer"))
  xFilePath <- file.path(rootPath, dataType, paste("X_", dataType, ".txt", sep=""))
  xTable <- read.table(xFilePath)
  xTable <- xTable[,featuresTable$V1]
  names(xTable) = featuresTable$V2
  
  activities = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
  yFilePath <- file.path(rootPath, dataType, paste("y_", dataType, ".txt", sep=""))
  yTable <- read.table(yFilePath, colClasses=c("integer"))
  
  for (i in 1:length(activities)) {
    yTable[yTable$V1 == i,] <- activities[i]
  }
  
  cbind(
    subject=subjectTable$V1,
    xTable,
    activity=yTable$V1
  )
}

tidyDataTable <- function(dataTable) {
  # This creates a skinny data set as in:
  # https://class.coursera.org/getdata-013/lecture/37
  dataMelt <- melt(dataTable, id=c("subject", "activity"))
  
  # For this dataset I chose to make it 66 columns (number of features)
  # long, with each "subject/activity" pair in a single row. This is called
  # a wide data format.
  #
  # Also, this function computes the mean for each feature for
  # each "subject/activity" pair.
  dcast(dataMelt, subject + activity ~ variable, mean)
}

downloadData()

rootPath <- file.path(".", "UCI HAR Dataset")

featuresTable <- loadFeaturesTable(rootPath)

tstTable <- loadData(rootPath, featuresTable, "test")
trnTable <- loadData(rootPath, featuresTable, "train")

dataTable <- rbind(tstTable, trnTable)

tidyTable <- tidyDataTable(dataTable)

write.table(tidyTable, "tidyData.txt", row.names=FALSE)

str(tidyTable)
