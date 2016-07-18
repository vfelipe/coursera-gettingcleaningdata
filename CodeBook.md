## CodeBook
This describes the variables, the data, and the transformations performed to clean up the data.

# Variables
* subject: identifier for the subject
* activity: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

# Measures - Average for each subject and activity
* tBodyAccMeanX
* tBodyAccMeanY
* tBodyAccMeanZ
* tBodyAccStdX
* tBodyAccStdY
* tBodyAccStdZ
* tGravityAccMeanX
* tGravityAccMeanY
* tGravityAccMeanZ
* tGravityAccStdX
* tGravityAccStdY
* tGravityAccStdZ
* tBodyAccJerkMeanX
* tBodyAccJerkMeanY
* tBodyAccJerkMeanZ
* tBodyAccJerkStdX
* tBodyAccJerkStdY
* tBodyAccJerkStdZ
* tBodyGyroMeanX
* tBodyGyroMeanY
* tBodyGyroMeanZ
* tBodyGyroStdX
* tBodyGyroStdY
* tBodyGyroStdZ
* tBodyGyroJerkMeanX
* tBodyGyroJerkMeanY
* tBodyGyroJerkMeanZ
* tBodyGyroJerkStdX
* tBodyGyroJerkStdY
* tBodyGyroJerkStdZ
* tBodyAccMagMean
* tBodyAccMagStd
* tGravityAccMagMean
* tGravityAccMagStd
* tBodyAccJerkMagMean
* tBodyAccJerkMagStd
* tBodyGyroMagMean
* tBodyGyroMagStd
* tBodyGyroJerkMagMean
* tBodyGyroJerkMagStd
* fBodyAccMeanX
* fBodyAccMeanY
* fBodyAccMeanZ
* fBodyAccStdX
* fBodyAccStdY
* fBodyAccStdZ
* fBodyAccMeanFreqX
* fBodyAccMeanFreqY
* fBodyAccMeanFreqZ
* fBodyAccJerkMeanX
* fBodyAccJerkMeanY
* fBodyAccJerkMeanZ
* fBodyAccJerkStdX
* fBodyAccJerkStdY
* fBodyAccJerkStdZ
* fBodyAccJerkMeanFreqX
* fBodyAccJerkMeanFreqY
* fBodyAccJerkMeanFreqZ
* fBodyGyroMeanX
* fBodyGyroMeanY
* fBodyGyroMeanZ
* fBodyGyroStdX
* fBodyGyroStdY
* fBodyGyroStdZ
* fBodyGyroMeanFreqX
* fBodyGyroMeanFreqY
* fBodyGyroMeanFreqZ
* fBodyAccMagMean
* fBodyAccMagStd
* fBodyAccMagMeanFreq
* fBodyBodyAccJerkMagMean
* fBodyBodyAccJerkMagStd
* fBodyBodyAccJerkMagMeanFreq
* fBodyBodyGyroMagMean
* fBodyBodyGyroMagStd
* fBodyBodyGyroMagMeanFreq
* fBodyBodyGyroJerkMagMean
* fBodyBodyGyroJerkMagStd
* fBodyBodyGyroJerkMagMeanFreq

# Source Data
UCI HAR Dataset was used and obtained from [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) and downloaded via this [link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
The files loaded were subject_test.txt, X_test.txt and y_test.txt for the test data; and subject_train.txt, X_train.txt, y_train.txt for the train data. 
```{r}
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
```

Additional files such as activity_labels.txt and features.txt were also loaded to fulfill the objecyive of the project.
```{r}
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")[,2]
```

# Libraries used
reshape2 library was used

# Transformations
* Set the headers
```{r}
names(X_train) <- features
names(X_test) <- features
names(subject_test) <- "subject"
names(subject_train) <- "subject"
names(y_train) <- "activity"
names(y_test) <- "activity"
```
* Extracted only needed features - mean and std columns
```{r}
f2 <- grepl("mean|std", features);
X_train2 <- X_train[,f2]
X_test2 <- X_test[,f2]
```
* Combined train and test data
```{r}
train_data <- cbind(subject_train, y_train, X_train2)
test_data <- cbind(subject_test, y_test, X_test2)
all_data <- rbind(train_data, test_data)
```
* Labelled activity names and cleaned header names
```{r}
all_data$activity <- factor(all_data$activity, labels = activities[,2])
names(all_data) <- gsub("-mean", "Mean", names(all_data))
names(all_data) <- gsub("-std", "Std", names(all_data))
names(all_data) <- gsub("[()-]", "", names(all_data))
```
* Compute mean for each subject and activity
```{r}
melted_data <- melt(all_data, id=c("subject","activity"))
tidy_data <- dcast(melted_data, subject+activity ~ variable, mean)
```
* Write data to file
```{r}
write.table(tidy_data, "tidydata.txt", row.names = FALSE)
```
