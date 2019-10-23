# Getting-and-Cleaning-Data-Course-Project

author: "ZKP"
date: "23 10 2019"
Course Project

This file explain how the analysis works.

Here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

There were following prerequisites for the task:
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement.
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names.
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Below you can find how each point was solved.

## 1.	Merges the training and the test sets to create one data set.
At the first step I set the working directory and import to **R** all necessary files from the training and test data sets.

```setwd("C:/Dane/MOJE/Zuzka/Coursera/DataScientistToolbox/Rscripts/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")```

I also set the column names and separator. Sep = "" allowed me to remove blank spaces. 

```activity_labels<-read.csv(file = "./activity_labels.txt", header = FALSE, sep = "", col.names = c("ID","Activity"))```
```features<-read.csv(file = "./features.txt", header = FALSE, sep = "", col.names = c("ID","Feature"))```

```subject_test<-read.csv(file = "./test/subject_test.txt", header = FALSE, sep = "", col.names = c("Subject"))```
```X_test<-read.csv(file = "./test/X_test.txt", header = FALSE, sep = "", col.names = features[, 2])```
```y_test<-read.csv(file = "./test/y_test.txt", header = FALSE, sep = "", col.names = c("ID"))```

```subject_train<-read.csv(file = "./train/subject_train.txt", header = FALSE, sep = "", col.names = c("Subject"))```
```X_train<-read.csv(file = "./train/X_train.txt", header = FALSE, sep = "", col.names = features[, 2])```
```y_train<-read.csv(file = "./train/y_train.txt", header = FALSE, sep = "", col.names = c("ID"))```

Bind_cols allows to add column from dirrerent train and test files.

```train<-bind_cols(subject_train, y_train, X_train)```
```test<-bind_cols(subject_test, y_test, X_test)```

Bind_rows allows to add rows from the train and test data set.

```step1<-bind_rows(train, test)```

## 2.	Extracts only the measurements on the mean and standard deviation for each measurement.
Select function allows to select appropriate columns from a data set created in the first step. I choose first two columns i.e. subject and ID and all those which contains either "mean" or "std" in the name.

```step2<-select(step1, 1:2, contains(".mean.."), contains(".std.."))```

## 3.	Uses descriptive activity names to name the activities in the data set
Merge function allows to add descriptive activity names to our data set by ID.

```step3<-merge(activity_labels, step2)```

## 4.	Appropriately labels the data set with descriptive variable names.
Gsub function is used to change the column names in our data set.

```
step4<-step3
names(step4)<-gsub("^t", "Time ", names(step4))
names(step4)<-gsub("^f", "Frequency ", names(step4))
names(step4)<-gsub("Acc", "Accelerometer ", names(step4))
names(step4)<-gsub("Gyro", "Gyroscope ", names(step4))
names(step4)<-gsub("Mag", "Magnitude ", names(step4))
names(step4)<-gsub("Body", "Body ", names(step4))
names(step4)<-gsub("Jerk", "Jerk ", names(step4))
names(step4)<-gsub("Gravity", "Gravity ", names(step4))
names(step4)<-gsub(".mean...", "MEAN ", names(step4))
names(step4)<-gsub(".std...", "STD ", names(step4))
names(step4)<-gsub(".mean..", "MEAN ", names(step4))
names(step4)<-gsub(".std..", "STD ", names(step4))
```

## 5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
The chain function used in this step allows to create the final tidy data set.

```
step5<-step4 %>%
  select(-ID) %>%
  group_by(Activity, Subject) %>%
  summarize_all(mean) %>%
  arrange(Activity, Subject)
```

The last function **write.table** allows to create a txt file, which is necessary to fulfill the submission requirements.

```write.table(step5, file = "./step5.txt", row.names = FALSE)```
