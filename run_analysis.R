
## 1. Merges the training and the test sets to create one data set.
#Set up directory
setwd("C:/me/Coursera/Getting and Cleaning data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")
#Load in datasets
Datatrain<- read.table("C:/me/Coursera/Getting and Cleaning data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
Labeltrain <- read.table("C:/me/Coursera/Getting and Cleaning data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
Subjecttrain <- read.table("C:/me/Coursera/Getting and Cleaning data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
Datatest <- read.table("C:/me/Coursera/Getting and Cleaning data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
Labeltest<- read.table("C:/me/Coursera/Getting and Cleaning data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt") 
Subjecttest <- read.table("C:/me/Coursera/Getting and Cleaning data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
#Merge the datasets by row (concatenate)
Datamerge <- rbind(Datatrain, Datatest)
Labelmerge <- rbind(Labeltrain, Labeltest)
Subjectmerge <- rbind(Subjecttrain, Subjecttest)


##2. Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table("C:/me/Coursera/Getting and Cleaning data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")
#Get columns whose variable names contain and really mean or std
meanStdInd <- grep("mean\\(\\)|std\\(\\)", features[, 2])#only extract variables whose name contain "mean()" and "std()"
Datamerge2 <- Datamerge[, meanStdInd]
#Rename mean and std variables (clolums)
names(Datamerge2) <- gsub("\\(\\)", "", features[meanStdInd, 2]) # remove "()"
names(Datamerge2) <- gsub("-", "", names(Datamerge2)) # remove "-" 

##3. Uses descriptive activity names to name the activities in the data set
activity <- read.table("C:/me/Coursera/Getting and Cleaning data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
#replace values of the only column in the Labelmerge dataset with acitivity names
Labelmerge[, 1] <- activity[Labelmerge[, 1], 2]
names(Labelmerge) <- "activity"

##4. Appropriately labels the data set with descriptive activity names. 
names(Subjectmerge) <- "subject"
tidydata1 <- cbind(Subjectmerge, Labelmerge, Datamerge2)#merge datasets by column
write.table(tidydata1, "tidydata1.txt") # export the first dataset

##5. creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
#Load necessary library
library(plyr)
tidydata2 <- ddply(tidydata1, .(subject, activity), function(x) colMeans(x[, 3:68]))#exlude column one and two because they are characters
write.table(tidydata2, "averagedataset.txt") 
