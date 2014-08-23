library(plyr)

path<-"C:/Documents and Settings/tbelay/Desktop/coursera/Getting and Cleaning Data/Project/data/UCI HAR Dataset/"


fileFeatures<-"features.txt"
dataFeatures<-read.table(paste0(path,fileFeatures))
#the file contains 561 observations by 2 varialbes
#I may need to split one of the variable into two using"-" as separator

fileActivity<-"activity_labels.txt"
dataActivity<- read.table(paste0(path,fileActivity))
colnames(dataActivity)<-c("No:","Activity")
#contains six observations containing the activities

##Inside Train folder

fileSubject_train<-"/train/subject_train.txt"
dataSubject_train<-read.table(paste0(path,fileSubject_train))
colnames(dataSubject_train)<-"subjects"
#contains 7352 0bservation and 1 variable. it has 21 unique values
# I think the unique values were supposed to be 30, I'm not sure if
#it is because some of them were taken for to "test"

fileY_train<-"/train/y_train.txt"
dataY_train<-read.table(paste0(path,fileY_train))
# contains 7352 ovservations by 1 variable
#It has 6 unique values 4,5,6,1,2,3. 

fileX_train<- "/train/X_train.txt"
dataX_train<-read.table(paste0(path,fileX_train))
# this contains 7352 observations by 561 variables

    
#The solutions starts from here

#1. this part works with the training data set
#cleaning the train variable names

dataFeatures[,2] <- sub("t", "Time", dataFeatures[,2])
dataFeatures[,2] <- sub("-", "_", dataFeatures[,2])
dataFeatures[,2] <- sub("-", "_", dataFeatures[,2])
dataFeatures[,2] <- sub("f", "Frequency", dataFeatures[,2])
dataFeatures[,2] <- sub("\\()", "", dataFeatures[,2])

# giving the colemn names for the training data
colnames(dataX_train)<-dataFeatures[,2]

#combining the training data with the subjects
data1<-cbind(dataSubject_train, dataX_train)

#Combining the training data with the activities 
#  colnames(dataActivity)<-c("ActivityCode", "Activity")
Activity_y_train<- merge(dataY_train, dataActivity, by.x="V1", by.y="No:")

data2<-cbind(Activity_y_train, data1)
# remove the first column, which is redendant as activity description is already exists
data2<-data2[,-1]

# grepl( "mean", dataFeatures[,2], ignore.case=TRUE, fixed=TRUE) |grepl("std", dataFeatures[,2], ignore.case=TRUE, fixed=TRUE))


#selecting the variable names that contain either 'mean' or 'std'
myvars<-c("Activity", "subjects", dataFeatures[(grepl( "mean", dataFeatures[,2], ignore.case=T) |grepl("std", dataFeatures[,2], ignore.case=T)),2])

finaltrainingdata<- data2[,myvars]

#2. this part works with the training data set

##Inside Test folder

fileSubject_test<-"/test/subject_test.txt"
dataSubject_test<-read.table(paste0(path,fileSubject_test))
colnames(dataSubject_test)<-"subjects"
# this file hase 2947 observation & 1 variable
#the file has 9 unique observations 2,4,9,10,12,13,18,20,24

fileY_test<-"/test/y_test.txt"
dataY_test<-read.table(paste0(path,fileY_test))
# this file has 2947 observation & 1 variable
#the file has 6 unique observations 5,4,6,1,3,2


fileX_test<- "/test/X_test.txt"
dataX_test<-read.table(paste0(path,fileX_test))
# this file contains 2947 observations by 561 variables

# giving the collemn names for the training data
colnames(dataX_test)<-dataFeatures[,2]

#combining the training data with the subjects
data3<-cbind(dataSubject_test, dataX_test)

#Combining the training data with the activities 
#  colnames(dataActivity)<-c("ActivityCode", "Activity")
Activity_y_test<- merge(dataY_test, dataActivity, by.x="V1", by.y="No:")

data4<-cbind(Activity_y_test, data3)
# remove the first column, which is redendant as activity description is already exists
data4<-data4[,-1]


#selecting the variable names that contain either 'mean' or 'std'
myvars<-c("Activity", "subjects", dataFeatures[(grepl( "mean", dataFeatures[,2], ignore.case=T) |grepl("std", dataFeatures[,2], ignore.case=T)),2])

finaltestdata<- data4[,myvars]

#Combining the final training data set and the final test data set

finalcombined_data<-rbind(finaltrainingdata,finaltestdata)

View(finalcombined_data)
write.table(finalcombined_data, "d:/tidydata.txt", sep="\t")
write.csv(finalcombined_data, file = "tidydata.csv",row.names=FALSE)

# addressing question 5

mean_finalcombined_data <- aggregate(finalcombined_data[,3:75], by=finalcombined_data[c("Activity", "subjects")], FUN=mean, decreasing=F)

View(mean_finalcombined_data )
write.table(mean_finalcombined_data, "d:/meantidydata.txt", sep="\t")


