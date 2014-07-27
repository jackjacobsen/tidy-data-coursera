
##  - You should create one R script called run_analysis.R that does the following. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


setwd("C:/Users/Jack/Documents/RData/data/UCI HAR Dataset")

##  Read in data from training set files, add activity + subject data
train <- read.table("./train/X_train.txt", stringsAsFactors = FALSE, row.names=NULL)
train$activity <- unlist(read.table("./train/Y_train.txt", stringsAsFactors = FALSE, row.names = NULL))
train$subject <- unlist(read.table("./train/subject_train.txt", stringsAsFactors = FALSE, row.names = NULL))

##  Read in datanames from test set files. add activity + subject data into a new data frame
test <- read.table("./test/X_test.txt", stringsAsFactors = FALSE, row.names=NULL)
test$activity <- unlist(read.table("./test/Y_test.txt", stringsAsFactors = FALSE, row.names = NULL))
test$subject <- unlist(read.table("./test/subject_test.txt", stringsAsFactors = FALSE, row.names = NULL))

##  Columns are identical, so we can merge the two sets with rbind (task 1)
merged <- rbind(train, test)    
rm(test, train)             ## Remove old datasets to conserve memory

##  Adding variable names to the merged data (from the feature.txt file) (task 4)
features <- read.table("features.txt", stringsAsFactors = FALSE)
colnames(merged) <- c(features[, 2], "activity", "subject")
rm(features)

##  Finding all columns that have 'mean' or 'std' in their name
columnsToExtract <- c(grep("[Mm]ean", names(merged)), grep("[Ss]td", names(merged)))
columnsToExtract <- sort(columnsToExtract)  ## Sorting to maintain original order

##  Extracting the mean and std columns - as well the 'activity' and 'subject' variables (task 2)
extractedData <- merged[, c(columnsToExtract, 562, 563)]
rm(merged); rm(columnsToExtract)

##  read in labels and levels from file and use them to convert the 'activity' variable to a factor (task 3)
labels <- read.table("activity_labels.txt", stringsAsFactors = FALSE)
extractedData$activity <- factor(extractedData$activity, levels = labels[, 1], labels = labels[, 2])

## Factorize the subject variable
extractedData$subject <- factor(extractedData$subject, levels = (seq(1:30)))

## Making a new(!) data frame, to which the required data are added, one column at the time
tidy <- data.frame(row.names = seq(1:180))  ## Initialize empty data frame

for (i in 1:86){
    tidy <- cbind(tidy, as.vector(tapply(extractedData[, i], list(extractedData$subject, extractedData$activity), mean)))   
}

colnames(tidy) <- colnames(extractedData)[1:86]
rm(extractedData, i)

## Adding subject and activity to match the output-pattern from the tapply function
tidy$Subject <- as.factor(cbind(rep(seq(1:30), 6)))
tidy$Activity <- factor(cbind(rep(labels[, 2], 30)), levels = labels[, 2], labels = labels[, 2])
rm(labels)

## Write the tidy dataset to file (tidy.txt) in the workspace folder
write.table(tidy, "./tidy.txt")

rm(tidy)