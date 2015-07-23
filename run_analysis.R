library(reshape2)

#path to the data
dataPath  = "data"

# STEP 1
# Extract from the fetures.txt file the measurements on the mean and extandard deviation to subset the data sets
################################################################################################################

# Load Features before to subset training and test dataset
dtFeatures <- read.table(file.path(dataPath,"features.txt"))
dtFeatures[,2] <- as.character(dtFeatures[,2])
featuresWanted <- grep(".*mean.*|.*std.*", dtFeatures[,2])
featuresWanted.names <- dtFeatures[featuresWanted,2]
featuresWanted.names <- gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names <- gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

# STEP 2
# Merges the training and test sets to create one data set subsetting with the features from the STEP 1
########################################################################################################

# Load Training Data
train <- read.table(file.path(dataPath, "train","x_train.txt"))[featuresWanted] #Subset with dev and mean fields
trainActivities <- fread(file.path(dataPath, "train","y_train.txt"))
trainSubjects <- fread(file.path(dataPath, "train", "subject_train.txt"))
train <- cbind(trainSubjects, trainActivities, train)

# Load Test Data
test <- read.table(file.path(dataPath, "test","x_test.txt"))[featuresWanted] #Subset with dev and mean fields
testActivities  <- fread(file.path(dataPath, "test","y_test.txt"))
testSubjects  <- fread(file.path(dataPath, "test" , "subject_test.txt" ))
test <- cbind(testSubjects, testActivities, test)

# Merge Data Sets
data <- rbind(train, test)

# STEP 3
# Use descriptive features names to name the features in the data set
# Use Descriptive actitivy names to name the activities in the data set
# Appropiately labels the data set with descriptive variable names
#######################################################################

# Add Features Labels
setNames(data,c("subject", "activity", featuresWanted.names))

# Add ACtivity Labels
activityLabels <- read.table(file.path(dataPath,"activity_labels.txt"))
activityLabels[,2] <- as.character(activityLabels[,2])

#Convert activities and subjects into factors
data$activity <- factor(data$activity, levels = activityLabels[,1], labels = activityLabels[,2])
data$subject <- as.factor(data$subject)

# STEP 4 
# From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.
###########################################################################################

# Melt the data by subject and activity
data.melted <- melt(data, id = c("subject", "activity"))

# Prepary the tidy data set, calculate the mean
data.tidy <- dcast(data.melted, subject + activity ~ variable, mean)

# Write tidy dataset to tidy.txt fiel
write.table(data.tidy, "tidy.txt", row.names = FALSE, quote = FALSE)
