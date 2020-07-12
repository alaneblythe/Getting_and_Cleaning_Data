#### Load required packages ####

library(dplyr)

#### Download dataset ####

project <- "getdata_projectfiles_UCI HAR Dataset.zip"

#### Check if file exists ####

if(!file.exists(project)) {
     projectURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
     download.file(projectURL, project, method = "curl")
}

#### Check if folder exists ####
     
if(!file.exists("UCI HAR Dataset")) {
     unzip(project)
}     

#### Assign data frames ####

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#### Merge training and test sets to create a single data frame ####

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merge <- cbind(Subject, Y, X)

#### Extract mean and SD measurements ####

Tidy_Data_1 <- Merge %>% select(subject, code, contains("mean"), contains("std"))

#### Name activities in data set ####

names(Tidy_Data_1)[2] = "activity"
names(Tidy_Data_1)<-gsub("Acc", "Accelerometer", names(Tidy_Data_1))
names(Tidy_Data_1)<-gsub("Gyro", "Gyroscope", names(Tidy_Data_1))
names(Tidy_Data_1)<-gsub("BodyBody", "Body", names(Tidy_Data_1))
names(Tidy_Data_1)<-gsub("Mag", "Magnitude", names(Tidy_Data_1))
names(Tidy_Data_1)<-gsub("^t", "Time", names(Tidy_Data_1))
names(Tidy_Data_1)<-gsub("^f", "Frequency", names(Tidy_Data_1))
names(Tidy_Data_1)<-gsub("tBody", "TimeBody", names(Tidy_Data_1))
names(Tidy_Data_1)<-gsub("-mean()", "Mean", names(Tidy_Data_1), ignore.case = TRUE)
names(Tidy_Data_1)<-gsub("-std()", "STD", names(Tidy_Data_1), ignore.case = TRUE)
names(Tidy_Data_1)<-gsub("-freq()", "Frequency", names(Tidy_Data_1), ignore.case = TRUE)
names(Tidy_Data_1)<-gsub("angle", "Angle", names(Tidy_Data_1))
names(Tidy_Data_1)<-gsub("gravity", "Gravity", names(Tidy_Data_1))

#### New data set with average of each variable per subject ####

Tidy_Data_2 <- Tidy_Data_1 %>%
     group_by(subject, activity) %>%
     summarize_all(tibble::lst(mean))
write.table(Tidy_Data_2, "tidy_data_2.txt", row.name = FALSE)

#### Check variable names ####

str(Tidy_Data_2)