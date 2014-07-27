#CodeBook

This file explains transformations by run_analysis.R script. run_analysis.R produces TidyData.txt from raw data.

## Raw Data

`./UCI HAR Dataset/activity_labels.txt (space-separated table)` — defines activityID to text label relation.

`./UCI HAR Dataset/features_info.txt (text)` — gives information about features in dataset.

`./UCI HAR Dataset/features.txt` (space-separated table, two columns) — defines featureID to text label relation.

`./UCI HAR Dataset/test/` — test subset of UCI HAR Dataset.

`./UCI HAR Dataset/train/` — train subset of UCI HAR Dataset.

`./UCI HAR Dataset/{test,train}/Inertial Signals` — not used.

`./UCI HAR Dataset/{test,train}/subject_{test,train}.txt` (one integer for each line) — subject ID for according tuple.

`./UCI HAR Dataset/{test,train}/X_{test,train}.txt` (space-separated table, 561 column) — for each subject there is a feature.

`./UCI HAR Dataset/{test,train}/y_{test,train}.txt` (one integer for each line) — activity.

### Some stats of raw data

Inertial Signals directory is ommited.

```
$wc UCI\ HAR\ Dataset/{test,train}/*
    2947     2947     7934 UCI HAR Dataset/test/subject_test.txt
    2947  1653267 26458166 UCI HAR Dataset/test/X_test.txt
    2947     2947     5894 UCI HAR Dataset/test/y_test.txt
    7352     7352    20152 UCI HAR Dataset/train/subject_train.txt
    7352  4124472 66006256 UCI HAR Dataset/train/X_train.txt
    7352     7352    14704 UCI HAR Dataset/train/y_train.txt
   30897  5798337 92513106 total
$wc UCI\ HAR\ Dataset/*
      6      12      80 UCI HAR Dataset/activity_labels.txt
     59     366    2809 UCI HAR Dataset/features_info.txt
    561    1122   15785 UCI HAR Dataset/features.txt
     70     576    4453 UCI HAR Dataset/README.txt
    696    2076   23127 total
```

## Tidy Data

Steps done by the run_analysis.R to create Tidy dataset.

### Step 0. Preparations

#### Refine feature labels

Substitutes:
- `-mean` `->` `-Mean`
- `-std` `->` `Std`

expands:
- preceding `t` `->` `time`
- preceding `f` `->` `freq`

remove all parenthesis (`Ux0028` `(`, `Ux0029` `)` ), minus sign (`Ux002D`, `-`) and comma (`Ux002C`, `,`)

#### create four column name sets:
- `colNamesAll` - all features, refined labels
- `colNamesAllN` - all features, labels not refined
- `colNamesStdMean` - only standard deviation and mean features, refined labels
- `colNamesStdMeanN` - only standard deviation and mean features, labels not refined

#### load all raw data

all features from `X_test.txt`, `y_test.txt`, `subject_test.txt`, `X_train.txt`, `y_train.txt`, `subject_train.txt` loaded into appropriate variables.

### Step 1. Merging

Merge raw data into one dataframe.

1. Merge X, y and subject by column in test and train subsets.

2. Merge test and train subsets by row.

### Step 2. Filtering

Extract only the mean and standard deviation features with `colNamesStdMean` variable.

### Steps 3, 4. Activity labels

Substitute ActivityID number identificators with text labels from `'./UCI HAR Dataset/activity_labels.txt'`. Results will be written in `UCI_MeanStd.txt` csv file

### Step 5. Calc averages

Create independent tidy data set with the average of each variable for each activity and each subject. Results will be written in `UCI_TidyData.txt` csv file
