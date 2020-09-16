## Data Cleaning Example

Data from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones was downloaded on 9/15/2020.

It is presented in its original form at the date of download in the directory "UCI HAR Dataset"
as well as in its new "clean" form in the directory "Cleaned UCI HAR Dataset"

For information on the original data see the original readme at "UCI HAR Dataset/README.txt"

The cleaned data includes two data files in .txt format

# The dataset includes the following files:

- 'README.md': This document

- 'CodeBook.Rmd': A code book that includes all the cleaned varibles in both files in the directory "Cleaned UCI HAR Dataset"

- 'run_analysis.R': R code that creates and populates the directory "Cleaned UCI HAR Dataset" from the directory "UCI HAR Dataset"

- 'UCI HAR Dataset/': The original dataset

- 'Cleaned UCI HAR Dataset/full_clean_uci_har_data.txt': The dataset in an organized data table including subject, readable activities, and all variables with a mean or std in original data labels

- 'Cleaned UCI HAR Dataset/idependent_tidy_subject_activities_means.txt': The means for each variable in the full_clean_uci_har_data.txt by subject and activity

# Notes: 
- ALL variables with an original name including "mean" or "std" were included using grep of "mean|std" on colnames
- To rerun code after cloning directory remember to delete the directory "Cleaned UCI HAR Dataset" before running run_analysis.R

# run_analysis.R

The single R script that that creates and populates the directory "Cleaned UCI HAR Dataset" from the directory "UCI HAR Dataset" is run_analysis.R.
It starts by defining a function that can build a single dataframe out of either the "UCI HAR Dataset/test/" or "UCI HAR Dataset/train/" files depending on
wheter it is passed "test" or "train". This involes adding the original variable names, adding in activiy information, and adding in subject information.
Reading the files is handled by read.table() except in the case of reading in the "~./X..." files which is large so fread is used to speed up reading the large file.

From then on we use the tidyverse to easily rbind the train and test data and perform steps 1-3.
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set

Then the column names are manipulated to form more readible variable names using gsub
4. Appropriately labels the data set with descriptive variable names.

Finally group_by in the tidyverse makes step 5 easy...
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The results are then written to "Cleaned UCI HAR Dataset/" using
``write.table(..., row.name=FALSE)``



