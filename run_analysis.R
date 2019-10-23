#1.	Merges the training and the test sets to create one data set.

setwd("C:/Dane/MOJE/Zuzka/Coursera/DataScientistToolbox/Rscripts/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")

library(dplyr)

activity_labels<-read.csv(file = "./activity_labels.txt", header = FALSE, sep = "", col.names = c("ID","Activity"))
features<-read.csv(file = "./features.txt", header = FALSE, sep = "", col.names = c("ID","Feature"))

subject_test<-read.csv(file = "./test/subject_test.txt", header = FALSE, sep = "", col.names = c("Subject"))
X_test<-read.csv(file = "./test/X_test.txt", header = FALSE, sep = "", col.names = features[, 2])
y_test<-read.csv(file = "./test/y_test.txt", header = FALSE, sep = "", col.names = c("ID"))

subject_train<-read.csv(file = "./train/subject_train.txt", header = FALSE, sep = "", col.names = c("Subject"))
X_train<-read.csv(file = "./train/X_train.txt", header = FALSE, sep = "", col.names = features[, 2])
y_train<-read.csv(file = "./train/y_train.txt", header = FALSE, sep = "", col.names = c("ID"))

train<-bind_cols(subject_train, y_train, X_train)
test<-bind_cols(subject_test, y_test, X_test)

step1<-bind_rows(train, test)

#2.	Extracts only the measurements on the mean and standard deviation for each measurement.

step2<-select(step1, 1:2, contains(".mean.."), contains(".std.."))

#3.	Uses descriptive activity names to name the activities in the data set

step3<-merge(activity_labels, step2)

#4.	Appropriately labels the data set with descriptive variable names.

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

#5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

step5<-step4 %>%
  select(-ID) %>%
  group_by(Activity, Subject) %>%
  summarize_all(mean) %>%
  arrange(Activity, Subject)

write.table(step5, file = "./step5.txt", row.names = FALSE)
  