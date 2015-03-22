# Getting and cleaning data - Course Project

For creating a tidy data set of wearable computing data originally from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Files in this repo
* README.md -- this file
* CodeBook.md -- codebook describing variables, the data and transformations
* run_analysis.R -- R script 

## run_analysis.R goals
You should create one R script called run_analysis.R that does the following:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

It should run in a folder of the Samsung data (the zip had this folder: UCI HAR Dataset)
The script assumes it has in it's working directory the following files and folders:
* activity_labels.txt
* features.txt
* test/
* train/

The output is created in working directory with the name of tidyDat.txt


## run_analysis.R walkthrough

* Preapration
  * Download and unzip file to working directory. The directory is set to be ~/R/UCI HAR Dataset

* Step 1:
  * Load in datasets (train, test), from respective subject_train.txt and y_train.txt
  * Column bind subjectID and activityID to respective train or test
  * Row bind train and test together to get the "dat" file
  * Then create column names for variables from features.txt and insert activityID and subjectID column names
  * The column name creation also used make.names() to get acceptable names that will be cleaned up later
  * Attached the column names to the data frame

* Step 2:
  * Using dplyr select columns containing "subjectID", "activityID", "mean" or "std"

* Step 3:
  * Use dply mutate() to replace column values in activityID as 
  * 1 => WALKING, 
2 => WALKING_UPSTAIRS, 
3 => WALKING_DOWNSTAIRS, 
4 => SITTING, 
5 => STANDING
, 6 => LAYING


* Step 4:
  * Pattern replace of column names
  
* Step 5:
  * Create new data frame of tidy data, tidyDat, using dply group_by then summarize
  * Launched View() to see the tidyDat
  
* Final step:
  * Write the new tidy set into a text file called tidyDat.txt in the working directory. Included a "," separator to make it easier for the next user.