#
# This script creates tidy data set from the UCI HAR Dataset
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

## 0. Prepare to hold your colour
features <- read.table("UCI HAR Dataset/features.txt")
colNames <- make.names(as.character(features[,2]))
remove(features)

train_x         <- read.table('./UCI HAR Dataset/train/X_train.txt',
                              col.names=colNames,
                              colClasses=rep.int("numeric",length(colNames)))
train_y         <- read.table('./UCI HAR Dataset/train/y_train.txt',
                              col.names="activityID")
train_subject   <- read.table('./UCI HAR Dataset/train/subject_train.txt',
                              col.names="subjectID")

test_x          <- read.table('./UCI HAR Dataset/test/X_test.txt',
                              col.names=colNames,
                              colClasses=rep.int("numeric",length(colNames)))
test_y          <- read.table('./UCI HAR Dataset/test/y_test.txt',
                              col.names="activityID")
test_subject    <- read.table('./UCI HAR Dataset/test/subject_test.txt',
                              col.names="subjectID")

## 1. Merge the training and the test sets
train   <- cbind(train_x, train_y, train_subject)
test    <- cbind(test_x, test_y, test_subject)
RawData <- rbind(train, test)
remove(train_x, train_y, train_subject,
       test_x, test_y, test_subject,
       train, test)

## 2. Extract the mean and standard deviation from each measurement
colNamesMeanStd <- c("subjectID",
                     "activityID",
                     grep("mean|std", x=colNames, value=TRUE))
MeanStdData <- RawData[, colNamesMeanStd]
remove(RawData, colNamesMeanStd)

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

## 5. Create independent tidy data set
##    with the average of each variable
##    for each activity and each subject.
TidyData <- aggregate(MeanStdData[,3:ncol(MeanStdData)],
                      list(subjectID=MeanStdData$subjectID,
                           activity=MeanStdData$activity),
                      mean)
TidyData <- data.frame(TidyData, row.names=NULL)
write.csv(TidyData, "UCI - tidy data.txt", row.names=FALSE)

