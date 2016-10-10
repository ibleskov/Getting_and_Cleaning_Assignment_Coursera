# Assignment: Getting and Cleaning Data

This is the Project Assignment for the Getting and Cleaning Data course of the Data Science Specialization (Coursera, Johns Hopkins Universityt).
The R script `run_analysis.R` does the following:

1. Checks the existance of the data and, if it is not the case, download the data set in the working directory
2. Loads the activity labels and features
3. Loads both test and training data sets and bind them selecting only those columns which describe means or standard deviations
4. Loads the activity and subject data for both test and training datasets
5. Merges the activity and subject columns with the data set from step 3
6. In the resulting data set changes the type of the activity and subject column to factor
7. By melting and casting the data set from step 6, creates another tidy data set containing the mean value of each variable (feature) for each subject and activity

Script also deletes unnecessary data.frames from memory during the execution.
The resulting tidy data set is saved in the file `tidy_dataset.txt`
