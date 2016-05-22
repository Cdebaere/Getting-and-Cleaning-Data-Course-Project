# Create one R script called run_analysis.R that does the following.
 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# 1. Merge the training and the test sets and training and test labels to create one data set. ---------

# Read in training and test set
train_set <- read.table(file = "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
test_set <- read.table(file = "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")

# Read in the training and test labels
train_labels <- read.table(file = "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", col.names="class_label")
test_labels <- read.table(file = "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt",col.names="class_label")

# Read in the training and test subject set
train_subject <- read.table(file = "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", col.names="subject")
test_subject <- read.table(file = "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", col.names="subject")

# Merge the two datasets by binding the rows and delete the original files
data_set <- rbind(train_set,test_set)
rm(list=c("train_set","test_set"))

data_labels <- rbind(train_labels,test_labels)
rm(list=c("train_labels","test_labels"))

data_subject <- rbind(train_subject,test_subject)
rm(list=c("train_subject","test_subject"))

# 2. Appropriately label the data set with descriptive variable names. ---------

# Read in the column names and transpose
features <- t(read.table(file = "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt"))[2,]

# match column names with the data set
names(data_set) <- features

# 3. Extract only the measurements on the mean and standard deviation for each measurement. ---------

# keep only those measurements with mean and standard deviation
data_set <- data_set[,grepl("mean()|std()", names(data_set))]

# bind columns of data_set and data_labels together
data_set <- cbind(data_subject,data_labels,data_set)
rm(list=c("data_labels","data_subject"))

# 4. Use descriptive activity names to name the activities in the data set. ---------

# Read in the activity labels
activity_labels <- read.table(file = "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", col.names=c("class_label","activity_name"))

# Name the activities in the data set
data_set <- merge(activity_labels, data_set, by="class_label")
data_set$class_label <- NULL

# 5. From the data_set, create a second, independent tidy data set with the average of each variable for each activity and each subject. ---------

tidy_dataset <- aggregate(. ~ activity_name + subject, data_set, function(x) mean(x))
write.table(tidy_dataset, file = "./tidy_dataset.txt", row.name=FALSE)
