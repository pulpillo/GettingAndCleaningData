# Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course.

The folder data contains the dta files using in this project, previously downloaded from:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

I change the order of some steps in order to clarify the algorithm.

The R script, `run_analysis.R`, does the following:

1. Extract from the fetures.txt file the measurements on the mean and extandard deviation to subset the data sets
2. Merges the training and test sets to create one data set subsetting with the features from the STEP 1
3. Use descriptive features names to name the features in the data set
   Use Descriptive actitivy names to name the activities in the data set
   Appropiately labels the data set with descriptive variable names
4. From the data set in step 4, creates a second, independent tidy data set with the average 
   of each variable for each activity and each subject.


The end result is shown in the file `tidy.txt`.