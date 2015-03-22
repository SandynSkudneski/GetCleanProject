# run_analysis.R

# Copyright statement: none
# Author comment: none
# File description
#   purpose: course project for Get and Clean Data, combine various data sets,
#            subset by variable and then group the output in tidy format.
#   inputs:  6 tables, 2 w/561 variables, 4 with 1 variable (ID)
#            train/test data tables - 7352/2947 obs, 561 variables
#            train/test subject and activity table - 7352/2947 obs, 1 variable/ea
#   outputs: 1 table of 10,299 obs, 563 variables
#            1 "tidy" table from the above table grouped by IDs in the activity
#            and subject tables.
# Function definitions: none

library(dplyr)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
setwd("~/R")
f <- file.path(getwd(), "UCI HAR Dataset.zip")
download.file(url, f)
unzip(f)
dat.dir <- file.path(getwd())
dat.dir <- file.path(paste0(getwd(), "/UCI HAR Dataset"))


# 1. Merges the training and the test sets to create one data set.
    # Load in datasets (train, test) and column bind subjectID and activityID and
    # take everything one step at a time

    trainData <- read.table(paste0(dat.dir, "/train/X_train.txt"))
    trainSubjectID <- read.table(paste0(dat.dir, "/train/subject_train.txt"))
    trainActivityID <- read.table(paste0(dat.dir, "/train/y_train.txt"))
    trainData <- bind_cols(trainSubjectID, trainActivityID, trainData)

    testData <- read.table(paste0(dat.dir, "/test/X_test.txt"))
    testSubjectID <- read.table(paste0(dat.dir, "/test/subject_test.txt"))
    testActivityID <- read.table(paste0(dat.dir, "/test/y_test.txt"))
    testData <- bind_cols(testSubjectID, testActivityID, testData)

    dat <- rbind(trainData, testData)

    # setup column names and apply
    mycols <- read.table(paste0(dat.dir, "/features.txt"), sep = " ")
    mycols <- matrix(mycols[,2])
    mycols <- make.names(mycols, unique=TRUE, allow_ = TRUE)
    mycols <- c("subjectID", "activityID", mycols)
    colnames(dat) <- mycols

# 2. Extracts only the measurements on the mean and standard deviation
#    for each measurement. 
    datS1 <- select(dat, contains("subjectID"), contains("activityID"),
                   contains("mean"), contains("std"))

# 3. Uses descriptive activity names to name the activities in the data set
    datS1 <- datS1 %>% mutate(activityID = 
                            ifelse(activityID == 1, "WALKING", 
                            ifelse(activityID == 2, "WALKING_UPSTAIRS", 
                            ifelse(activityID == 3, "WALKING_DOWNSTAIRS", 
                            ifelse(activityID == 4, "SITTING", 
                            ifelse(activityID == 5, "STANDING", 
                            ifelse(activityID == 6, "LAYING", "N/A")))))))

# 4. Appropriately labels the data set with descriptive variable names.
    names(datS1) <- sub("\\.+$", "", names(datS1))
    names(datS1) <- sub("tBody", "time.Body.",
                    sub("tGravity", "time.Gravity.",
                    sub("fBody", "FFT.Body",
                    sub("fGravity", "FFT.Gravity",
                        names(datS1)))))

    # took these one at a time to prevent "axisaxis", 
    # didn't troubleshoot the issue
    names(datS1) <- sub("...X", ".Xaxis", names(datS1))
    names(datS1) <- sub("...Y", ".Yaxis", names(datS1))
    names(datS1) <- sub("...Z", ".Zaxis", names(datS1))

# 5. From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.
    tidyDat <- group_by(datS1, activityID, subjectID) %>% summarise_each(funs(mean))
    View(tidyDat)
    write.table(tidyDat, paste0(dat.dir, "/tidyDat.txt"), sep = ",", row.name=FALSE)
