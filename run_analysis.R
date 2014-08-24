#0. read data
df_Xtrain <- read.table('UCI HAR Dataset/train/X_train.txt')
df_ytrain <- read.table('UCI HAR Dataset/train/y_train.txt')
subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt')
df_Xtest <- read.table('UCI HAR Dataset/test/X_test.txt')
df_ytest <- read.table('UCI HAR Dataset/test/y_test.txt')
subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt')


#1. Merges the training and the test sets to create one data set.
df_X <- rbind(df_Xtrain, df_Xtest)
df_y <- rbind(df_ytrain, df_ytest)
subjects <- rbind(subject_train, subject_test)


#2.Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table('UCI HAR Dataset/features.txt')
#rename columns
colnames(df_X) <- features[,2]
#using `grepl` to extract columns
df_X <- df_X[,grepl('mean|std',colnames(df_X))]


#3. Uses descriptive activity names to name the activities in the data set
activities <- read.table('UCI HAR Dataset/activity_labels.txt')
df_y <- activities[as.matrix(df_y),2]


#4. Appropriately labels the data set with descriptive variable names. 
# I think this is done above...


#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
data <- cbind(df_y, subjects, df_X)
colnames(data) <- c('activity', 'subject', colnames(df_X))
groups = split(data,list(data$activity,data$subject))
output <- data.frame()

for(g in groups){
  dt <- data.frame(g)
  index <- dt[1,1:2]
  dt <- dt[,2:dim(dt)[2]]
  output <- rbind( output, c(index,colMeans(dt)) )
}

write.table(output, file='ouput.csv')

