
==================================================================

GETTING AND CLEANING DATA - COURSE PROJECT

Tesfaye Belay, August 2014

==================================================================

This is a codebook for the tidy data that is achieved after processing the data collected from the accelerometers from the Samsun Galaxy S smartphone.
The original data contains data for the training and test sets of individuals with regard to their activities in separate files. The project for the
"Getting and cleaning data" coursera course requires to clean and put together some of these files. 

The final tidy dataset is achieved after:

	1.openning the relevant data, 
	2. merging the training and test datasets
	3.extracting the mean and standard devations of each measurement
	4. finally giving the variables more descriptive names

The whole process is done using R. How the R scripts work is explained in this file.

The original data can be found on (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

==================================================================

##### opening the training dataset

```{r}
	library(plyr)
	path<- getwd()

	fileFeatures<-"features.txt"
	dataFeatures<-read.table(paste0(path,fileFeatures))

	fileActivity<-"activity_labels.txt"
	dataActivity<- read.table(paste0(path,fileActivity))
	colnames(dataActivity)<-c("No:","Activity")

```

	######Inside Train folder

```{r}

	fileSubject_train<-"/train/subject_train.txt"
	dataSubject_train<-read.table(paste0(path,fileSubject_train))
	colnames(dataSubject_train)<-"subjects"
	
	fileY_train<-"/train/y_train.txt"
	dataY_train<-read.table(paste0(path,fileY_train))

	fileX_train<- "/train/X_train.txt"
	dataX_train<-read.table(paste0(path,fileX_train))

```

##### tidying the training dataset

```{r}
	dataFeatures[,2] <- sub("t", "Time", dataFeatures[,2])
	dataFeatures[,2] <- sub("-", "_", dataFeatures[,2])
	dataFeatures[,2] <- sub("-", "_", dataFeatures[,2])
	dataFeatures[,2] <- sub("f", "Frequency", dataFeatures[,2])
	dataFeatures[,2] <- sub("\\()", "", dataFeatures[,2])

	colnames(dataX_train)<-dataFeatures[,2]
```
#combining the training data with the subjects and the activities data

```{r}

	data1<-cbind(dataSubject_train, dataX_train)
	Activity_y_train<- merge(dataY_train, dataActivity, by.x="V1", by.y="No:")
	data2<-cbind(Activity_y_train, data1)

```

###### remove the first column(ActivityCode), which is redendant as activity description already exists

```{r}

	data2<-data2[,-1]

```

######selecting the variable names that contain either 'mean' or 'std' and obtaining the final required training data set. This dataset will be merged with the test dataset later.

```{r}

	myvars<-c("Activity", "subjects", dataFeatures[(grepl( "mean", dataFeatures[,2], ignore.case=T) |grepl("std", dataFeatures[,2], ignore.case=T)),2])

	finaltrainingdata<- data2[,myvars]

```

#### Similarly opening and cleaning the test data set

```{r}

	fileSubject_test<-"/test/subject_test.txt"
	dataSubject_test<-read.table(paste0(path,fileSubject_test))
	colnames(dataSubject_test)<-"subjects"

	fileY_test<-"/test/y_test.txt"
	dataY_test<-read.table(paste0(path,fileY_test))

	fileX_test<- "/test/X_test.txt"
	dataX_test<-read.table(paste0(path,fileX_test))
	
```
##### tidying the test dataset and combining it with the subject and activities

```{r}
	colnames(dataX_test)<-dataFeatures[,2]

	data3<-cbind(dataSubject_test, dataX_test)
	Activity_y_test<- merge(dataY_test, dataActivity, by.x="V1", by.y="No:")

	data4<-cbind(Activity_y_test, data3)

```
###### remove the first column, which is redendant as activity description is already exists

```{r}

	data4<-data4[,-1]

```

######selecting the variable names that contain either 'mean' or 'std'and obtaining the final required test dataset. This dataset will be merged with the training dataset.

```{r}

	myvars<-c("Activity", "subjects", dataFeatures[(grepl( "mean", dataFeatures[,2], ignore.case=T) |grepl("std", dataFeatures[,2], ignore.case=T)),2])

	finaltestdata<- data4[,myvars]

```

#####Combining the final training data set and the final test data set

```{r}

finalcombined_data<-rbind(finaltrainingdata,finaltestdata)

```


#####Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```{r}

	mean_finalcombined_data <- aggregate(finalcombined_data[,3:75], by=finalcombined_data[c("Activity","subjects")], FUN=mean)
write.table(mean_finalcombined_data, "d:/meantidydata.txt", sep="\t")

```