#
# This script creates tidy data set from the UCI HAR Dataset
# Please consult with CodeBook.md
# 
# Done according to course project for Coursera
# 'Getting and Cleaning Data' course:
# https://class.coursera.org/getdata-005/
#
# raw data:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# UCI HAR dataset info:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
# @author: Aleksey Krasnobaev, https://github.com/krasnobaev/
# 07/2014
#

## 0.0 Refine feature labels
featuresAll <- read.table("UCI HAR Dataset/features.txt")
features <- featuresAll
featuresAll[,3] <- featuresAll[,2]
featuresAll[,2] <- gsub("-mean", "-Mean", featuresAll[,2])
featuresAll[,2] <- gsub("-std", "-Std", featuresAll[,2])
featuresAll[,2] <- gsub("^t", "time", featuresAll[,2])
featuresAll[,2] <- gsub("^f", "freq", featuresAll[,2])
featuresAll[,2] <- gsub('\\(|\\)', "", featuresAll[,2]) # remove brackets
featuresAll[,2] <- gsub("-", "", featuresAll[,2])
featuresAll[,2] <- gsub(",", "", featuresAll[,2])

# column names with all features
colNamesAll  <- make.names(as.character(featuresAll$V2))
colNamesAllN <- make.names(as.character(featuresAll$V3))

# column names with only mean & std features
features <- featuresAll[grepl("Mean|Std", x=featuresAll$V2),]
colNamesStdMean  <- make.names(as.character(features$V2))
colNamesStdMeanN <- make.names(as.character(features$V3))

remove(features, featuresAll)

## 0.1 Load raw data (all features)
train_x         <- read.table('./UCI HAR Dataset/train/X_train.txt',
                              col.names=colNamesAll,
                              colClasses=rep.int("numeric", length(colNamesAll)))
train_y         <- read.table('./UCI HAR Dataset/train/y_train.txt',
                              col.names="activityID")
train_subject   <- read.table('./UCI HAR Dataset/train/subject_train.txt',
                              col.names="subjectID")

test_x          <- read.table('./UCI HAR Dataset/test/X_test.txt',
                              col.names=colNamesAll,
                              colClasses=rep.int("numeric", length(colNamesAll)))
test_y          <- read.table('./UCI HAR Dataset/test/y_test.txt',
                              col.names="activityID")
test_subject    <- read.table('./UCI HAR Dataset/test/subject_test.txt',
                              col.names="subjectID")

## 1. Merge the training and the test sets
train   <- cbind(train_subject, train_y, train_x)
test    <- cbind(test_subject, test_y, test_x)
RawData <- rbind(train, test)
remove(train_x, train_y, train_subject,
       test_x, test_y, test_subject,
       train, test)

## 2. Extract the mean and standard deviation from each measurement
colNamesStdMeanSA <- c("subjectID", "activityID", colNamesStdMean)
MeanStdData <- RawData[, colNamesStdMeanSA]
remove(RawData, colNamesStdMeanSA)

## 3. Use descriptive activity names
##    to name the activities in the data set
activity <- read.table('./UCI HAR Dataset/activity_labels.txt',
                       col.names=c("activityID", "activity"), 
                       colClasses=c("numeric", "character"))
a <- as.factor(MeanStdData[,2])
levels(a) <- c(as.vector(activity$activity[order(activity$activity)]))

## 4. Label the data set with descriptive variable names
MeanStdData[,2] <- a
colnames(MeanStdData)[2] <- "activity"
remove(a, activity)
write.csv(MeanStdData, "UCI_MeanStd.txt", row.names=FALSE)

## 5. Create independent tidy data set
##    with the average of each variable
##    for each activity and each subject.
TidyData <- aggregate(MeanStdData[,3:ncol(MeanStdData)],
                      list(subjectID=MeanStdData$subjectID,
                           activity=MeanStdData$activity),
                      mean)
TidyData <- data.frame(TidyData, row.names=NULL)
write.csv(TidyData, "UCI_TidyData.txt", row.names=FALSE)
