

library(dplyr)

temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp, mode="wb")
unzip(temp)
#read in required data and join
#main results
train <- read.table("UCI HAR Dataset/train/X_train.txt")
test <- read.table("UCI HAR Dataset/test/X_test.txt")
#remove unnecessary columns; retain mean and stdev
features <- read.table("UCI HAR Dataset/features.txt")
train <- train[grep(".*mean.*|.*std.*", features[,2])]
test <- test[grep(".*mean.*|.*std.*", features[,2])]
#activities
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
#subjects
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
#union dataset rows
results <- rbind(train, test)
activities <- rbind(trainActivities, testActivities)
subjects <- rbind(trainSubjects, testSubjects)
#add Column Headers
colnames(results) <- features[grep(".*mean.*|.*std.*", features[,2]),2]
colnames(activities) <- "activity"
colnames(subjects) <- "subjects"
#join data set columns
joinedData <- cbind(subjects, activities, results)
#Replace activity values with labels
activityNames <- read.table("UCI HAR Dataset/activity_labels.txt")
joinedData$activity <- factor(joinedData$activity, levels = activityNames[,1], labels = activityNames[,2])

#create table of averages
tidyData <- joinedData %>%
  group_by(subjects, activity) %>%
  summarise_each(funs(mean(., na.rm=TRUE)))
#save table to wd
write.table(tidyData, "tidy.txt", row.names = FALSE, quote = FALSE)
