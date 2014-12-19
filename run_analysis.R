## Getting and Cleaning Data assignment for Peter Ashcroft

## Read in all the data from the archive
x_test <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

x_train <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

features <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")
activity_labels <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")


## 1) Merge the training and the test sets to create one data set.
data <- rbind(cbind(x_train,subject_train,y_train),
              cbind(x_test,subject_test,y_test))
# Add column names
colnames(data) <- features[,2]
colnames(data)[562:563] <- c("Subject","Activity")


## 2) Extract only the measurements on the mean and standard deviation for each measurement. 
# The list of features to keep was generated offline, by selecting only those features that are means or stds
features_to_keep <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features(columns to be extracted).txt")
data_means_std <- data[,c(as.character(features_to_keep[,2]),"Subject","Activity")]


## 3) Use descriptive activity names to name the activities in the data set
data_means_std[,"Activity"] <- activity_labels[data_means_std[,"Activity"],2]


## 4) Appropriately label the data set with descriptive variable names. 
# The cleaned list of features was generated offline.
clean_descriptors <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features(clean variable names).txt")
colnames(data_means_std) <- clean_descriptors[,2]
colnames(data_means_std)[67:68] <- c("Subject","Activity")


## 5) From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
data_means <- aggregate(data_means_std[,1:66],by=list(data_means_std$Activity,data_means_std$Subject),mean)
# Swap first two columns for aesthetic reasons
data_means <- cbind(data_means[,2],data_means[,1],data_means[,3:68])
# Label first two columns
colnames(data_means)[1:2] <- c("Subject","Activity")


## Write the resulting table
write.table(data_means,"tidy_data_means.txt",row.names = FALSE)
