#Loading all the Data Files

xTrain = read.table(file.path(paste(getwd(), "/UCI HAR Dataset", sep = ""), "train", "x_train.txt"), header = FALSE)
xTest = read.table(file.path(paste(getwd(), "/UCI HAR Dataset", sep = ""), "test", "X_test.txt"), header = FALSE)

yTrain = read.table(file.path(paste(getwd(), "/UCI HAR Dataset", sep = ""), "train", "y_train.txt"), header = FALSE)
yTest = read.table(file.path(paste(getwd(), "/UCI HAR Dataset", sep = ""), "test", "y_test.txt"), header = FALSE)

sub_train = read.table(file.path(paste(getwd(), "/UCI HAR Dataset", sep = ""), "train", "subject_train.txt"), header = FALSE)
sub_test = read.table(file.path(paste(getwd(), "/UCI HAR Dataset", sep = ""), "test", "subject_test.txt"), header = FALSE)

features = read.table(file.path(paste(getwd(), "/UCI HAR Dataset", sep = ""), "features.txt"), header = FALSE)

activityLabels = read.table(file.path(paste(getwd(), "/UCI HAR Dataset", sep = ""), "activity_labels.txt"), header = FALSE)


#Adding column names to make the data more readable and understandable

colnames(xTrain) = features[, 2]
colnames(xTest) = features[, 2]

colnames(yTrain) = "ActivityID"
colnames(yTest) = "ActivityID"

colnames(sub_train) = "SubjectID"
colnames(sub_test) = "SubjectID"

colnames(activityLabels) <- c('ActivityID', 'ActivityType') 

train <- cbind(yTrain, sub_train, xTrain)
test <- cbind(yTest, sub_test, xTest)


#Merging all the training/testing data into a single dataset 

my_data <- rbind(train, test)


#Extracting the measurements of Mean and Standard Deviation

names <- colnames(my_data)

mean_std = grepl("ActivityID", names) | grepl("SubjectID", names) | grepl("mean..", names) | grepl("std..", names)

Measurement_Data <- my_data[ , mean_std == TRUE]



#Appropriately labeling the dataset by fixing column names

names(Measurement_Data) <- gsub("^t", "time", names(Measurement_Data))
names(Measurement_Data) <- gsub("^f", "frequency", names(Measurement_Data))
names(Measurement_Data) <- gsub("Gyro", "Gyroscope", names(Measurement_Data))
names(Measurement_Data) <- gsub("Acc", "Accelerometer", names(Measurement_Data))
names(Measurement_Data) <- gsub("BodyBody", "Body", names(Measurement_Data))
names(Measurement_Data) <- gsub("Mag", "Magnitude", names(Measurement_Data))

ActivityNames_Dataset <- merge(Measurement_Data, activityLabels, by = 'ActivityID', all.x = TRUE)



#Creating tidy dataset with the average of each variable for each activity and subject

Tidy_Dataset <- ActivityNames_Dataset %>% group_by(ActivityType, SubjectID) %>% summarize_each(funs(mean))

#Creating an output File called "Tidy Data"

write.table(Tidy_Dataset, "Tidy Data.txt", row.names = FALSE)
