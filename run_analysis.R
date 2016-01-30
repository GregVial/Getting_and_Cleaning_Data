# Load packages
library(reshape)

## Update the following line to set proper working directory
workdir<-"C:/Users/vialgre/Desktop/DataScience/Getting and Cleaning Data/UCI HAR Dataset"
setwd(workdir)

## Load activity labels and features
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

## Load test data
X_test <- read.table("test/X_test.txt")

y_test <- read.table("test/y_test.txt")
y_test$V2<-activity_labels[y_test$V1,2]

subject_test <- read.table("test/subject_test.txt")

test_data <- cbind(subject_test, y_test, X_test)

## Load train data
X_train <- read.table("train/X_train.txt")

y_train <- read.table("train/y_train.txt")
y_train$V2<-activity_labels[y_train$V1,2]

subject_train <- read.table("train/subject_train.txt")

train_data <- cbind(subject_train, y_train, X_train)

## 1. Merges the training and the test sets to create one data set
all_data <- rbind(test_data,train_data)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement
features_filter <- grepl("mean|std",features$V2)
useful_data <- all_data[,features_filter]

## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
col_names <- c("Subject","Activity_ID", "Activity_Name",as.character(features$V2[features_filter]))
names(useful_data) <- col_names

## 5. From the data set in step 4, creates a second, independent tidy data set with the 
##  average of each variable for each activity and each subject
melted_data <- melt(useful_data,id=c("Subject","Activity_ID","Activity_Name"))
tidy_data <- cast(melted_data,Subject+Activity_Name~variable, mean)

## Write the output
file_name <- "tidy_data.txt"
write.table(tidy_data,file_name)
