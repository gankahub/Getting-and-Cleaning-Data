#calling necessary library
library(dplyr)

#creating data directory
if(!file.exists("data")){
  dir.create("data")
}

#downloading zip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip",method="curl")

#unzipping file
unzip("./data/Dataset.zip",exdir="./data")

#import activity labels
import_activity_labels <-read.table("./data/UCI HAR Dataset/activity_labels.txt" , sep = " " , header=FALSE)

#importing features
import_features <- read.table("./data/UCI HAR Dataset/features.txt")

#importing test datasets
import_subject_test <-read.table("./data/UCI HAR Dataset/test/subject_test.txt" , sep = " " , header=FALSE)
import_X_test <-read.table("./data/UCI HAR Dataset/test/X_test.txt")
import_y_test <-read.table("./data/UCI HAR Dataset/test/y_test.txt" , sep = " " , header=FALSE)

#importing training dataset
import_subject_train <-read.table("./data/UCI HAR Dataset/train/subject_train.txt" , sep = " " , header=FALSE)
import_X_train <-read.table("./data/UCI HAR Dataset/train/X_train.txt")
import_y_train <-read.table("./data/UCI HAR Dataset/train/y_train.txt" , sep = " " , header=FALSE)

#binding test and training datasets
subject <- rbind(import_subject_test,import_subject_train)
X <- rbind(import_X_test,import_X_train)
y <- rbind(import_y_test,import_y_train)

#Adding meaningful column names
colnames(import_activity_labels) = c('y','activity')
colnames(subject) <- "subject"
colnames(y) <- "y"
colnames(X) <- import_features[,2]

#Selecting mean and standard deviation columns
tmp_std <- grep(pattern="-std()",import_features[,2])
tmp_mean <- grep(pattern="-mean()",import_features[,2],fixed=TRUE)

#removing unwanted columns
X <- cbind(X[,tmp_std],X[,tmp_mean])

#binding datasets
test_data_excluding_X <- cbind(subject,y)
test_data <- cbind(test_data_excluding_X,X)

#Merging on activity labels
merge_data <- merge(test_data,import_activity_labels,by.x="y",by.y="y",all=TRUE)

#Summarising data
TidyDataSet <- merge_data %>% group_by(activity,subject) %>% summarise_each(funs(mean))

#outputing dataset
write.table(TidyDataSet,file="Final_Output.txt",row.name=FALSE)
