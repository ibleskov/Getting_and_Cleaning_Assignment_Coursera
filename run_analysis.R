library(reshape2)

## Download source data set
print("Downloading files...") # User can see what's going on
filename <- "source_data.zip"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists(filename)) {
    download.file(fileUrl,
                  filename,
                  method = "curl")
}
if (!file.exists("UCI HAR Dataset")) {
    unzip(filename)
    # substitute spaces in filenames to "_"
    system("mv 'UCI\ HAR\ Dataset' UCI_HAR_Dataset")
}
print("Done.")

## Get data to workspace
print("Loading data...")
# load activity names
activity_labels <- read.table("./UCI_HAR_Dataset/activity_labels.txt")

# load feature names
features <- read.table("./UCI_HAR_Dataset/features.txt")
# get only needed column names
featureNames <- features[grep(".*mean.*|.*std.*", 
                              features$V2)
                         ,]
# clean workspace from unnecessary data
rm(features)

# load test and training data sets
X_test <- read.table("./UCI_HAR_Dataset/test/X_test.txt")
X_train <- read.table("./UCI_HAR_Dataset/train/X_train.txt")
# merge them
X <- rbind(X_test, X_train)
# keep only needed columns
X <- X[, featureNames[,1]]
# give proper names to columns
colnames(X) <- featureNames[,2]
# clean workspace
rm(X_test, X_train)

# load subject data for test and training sets
people_test <- read.table("./UCI_HAR_Dataset/test/subject_test.txt")
people_train <- read.table("./UCI_HAR_Dataset/train/subject_train.txt")
# merge them
people <- rbind(people_test, people_train)
# give proper name
colnames(people) <- "subject"
# clean workspace
rm(people_test, people_train)

# load activity data for test and training sets
activity_test <- read.table("./UCI_HAR_Dataset/test/y_test.txt")
activity_train <- read.table("./UCI_HAR_Dataset/train/y_train.txt")
# merge them
activity <- rbind(activity_test, activity_train)
# give proper name
colnames(activity) <- "activity"
# clean workspace
rm(activity_test, activity_train)
print("Done.")

## Tidying data to get the required data set
print("Tidying data...")
# merge needed data
res <- cbind(people, activity, X)
# clean workspace
rm(people, activity, X)
# change the type of activity to get descriptive names 
# for the activities in the data set
res$activity <- factor(res$activity,
                       levels = activity_labels$V1,
                       labels = activity_labels$V2)
res$subject <- factor(res$subject)

## Get required tidy data with the average of each variable for each activity 
## and each subject.
# melt (via reshape2) the res data.frame to the form convinient for further 
# analysis
resMelted <- melt(res, id = c("subject", "activity"))
# get mean values of each variable (i.e. feature) for each activity and each 
# subject
resOut <- dcast(resMelted,
                subject + activity ~ variable,
                mean)
# clean workspace
rm(res, resMelted)

## Save the result to a file
# make column names more neat
n <- sub("\\(\\)-*", "", names(resOut))
n <- sub("-mean", "Mean", n)
n <- sub("-std", "Std", n)
# rename columns
names(resOut) <- n
print("Done.")
# save tidy data set to 'tidy_dataset.txt'
write.table(resOut, 
            "./tidy_dataset.txt", 
            sep = " ", 
            row.names = FALSE)
print("Tidy data set saved to 'tidy_dataset.txt")