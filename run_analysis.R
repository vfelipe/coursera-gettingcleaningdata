
library(reshape2)

# Load train data
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Load test data
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Read features
features <- read.table("UCI HAR Dataset/features.txt")[,2]

# Set headers
names(X_train) <- features
names(X_test) <- features
names(subject_test) <- "subject"
names(subject_train) <- "subject"
names(y_train) <- "activity"
names(y_test) <- "activity"

# Extract only mean and std features
f2 <- grepl("mean|std", features);
X_train2 <- X_train[,f2]
X_test2 <- X_test[,f2]

# Combine test and train data
train_data <- cbind(subject_train, y_train, X_train2)
test_data <- cbind(subject_test, y_test, X_test2)
all_data <- rbind(train_data, test_data)

# Label activity names
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
all_data$activity <- factor(all_data$activity, labels = activities[,2])

# Clean header names
names(all_data) <- gsub("-mean", "Mean", names(all_data))
names(all_data) <- gsub("-std", "Std", names(all_data))
names(all_data) <- gsub("[()-]", "", names(all_data))

# Compute mean for each subject and activity
melted_data <- melt(all_data, id=c("subject","activity"))
tidy_data <- dcast(melted_data, subject+activity ~ variable, mean)

# Write data to file
write.table(tidy_data, "tidydata.txt", row.names = FALSE)

