library(reshape2)

#path to the data
dataPath  = "data"

#Load Features before to subset training and test dataset
dtFeatures <- read.table(file.path(dataPath,"features.txt"))
dtFeatures[,2] <- as.character(dtFeatures[,2])
featuresWanted <- grep(".*mean.*|.*std.*", dtFeatures[,2])
featuresWanted.names <- dtFeatures[featuresWanted,2]
featuresWanted.names <- gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names <- gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

#Load Training Data
train <- read.table(file.path(dataPath, "train","x_train.txt"))[featuresWanted] #Subset with dev and mean fields
trainActivities <- fread(file.path(dataPath, "train","y_train.txt"))
trainSubjects <- fread(file.path(dataPath, "train", "subject_train.txt"))
train <- cbind(trainSubjects, trainActivities, train)

#Load Test Data
test <- read.table(file.path(dataPath, "test","x_test.txt"))[featuresWanted] #Subset with dev and mean fields
testActivities  <- fread(file.path(dataPath, "test","y_test.txt"))
testSubjects  <- fread(file.path(dataPath, "test" , "subject_test.txt" ))
test <- cbind(testSubjects, testActivities, test)

# Merge Data Sets
data <- rbind(train, test)

#Add Labels
#Not best performance, should change it to setnames.
colnames(data) <- c("subject", "activity", featuresWanted.names)

#Load ACtivity Labels
activityLabels <- read.table(file.path(dataPath,"activity_labels.txt"))
activityLabels[,2] <- as.character(activityLabels[,2])

#Convert activities and subjects into factors
data$activity <- factor(data$activity, levels = activityLabels[,1], labels = activityLabels[,2])
data$subject <- as.factor(data$subject)

#Melt the data by subject and activity
data.melted <- melt(data, id = c("subject", "activity"))

#Prepary the tidy data set
data.tidy <- dcast(data.melted, subject + activity ~ variable, mean)

write.table(data.tidy, "tidy.txt", row.names = FALSE, quote = FALSE)
