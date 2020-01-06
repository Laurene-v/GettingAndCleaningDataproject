
library(magrittr)
library(dplyr)

#1 : Merges the training and the test sets to create one data set.

#setwd("~/R/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")

#Creating a function to open the training and testing sets correponding to the name of the file set in argument of the function
merge_test_train <- function(name_dataset){
  
  #Creating new names: test/name_dataset_test.txt and train/name_dataset_train.txt
  test_name = paste("test/",name_dataset, "_test.txt", sep = "")
  train_name= paste("train/", name_dataset, "_train.txt", sep = "")
  #print(test_name)
  
  #Reading the datasets
  test_set <- read.csv(test_name, sep = "", header = FALSE)
  train_set <- read.csv(train_name, sep = "", header = FALSE)

  #Merging them : 
  merged_set <- rbind(test_set,train_set)
  return (merged_set)
  
}

#print(head(merge_test_train("subject")))


#We can now easily merge all the other files : 
#--------------- merging : ---------------------
Person<-merge_test_train("subject")
Xvalues<-merge_test_train("X")
Ylabels<-merge_test_train("Y")


#files in Inertial Signals : 
#merge_test_train("Inertial Signals/body_acc_x")
#merge_test_train("Inertial Signals/body_acc_y")
#merge_test_train("Inertial Signals/body_acc_z")

#merge_test_train("Inertial Signals/body_gyro_x")
#merge_test_train("Inertial Signals/body_gyro_y")
#merge_test_train("Inertial Signals/body_gyro_z")

#merge_test_train("Inertial Signals/total_acc_x")
#merge_test_train("Inertial Signals/total_acc_y")
#merge_test_train("Inertial Signals/total_acc_z")

#-------------end of merging -------------------

# Reading the features and activity labels files : 

features <- read.csv("features.txt", sep = "", header = FALSE)[2] #we only take the second row into account as it is the only useful information
#head(features)
activity_labels <- read.csv("activity_labels.txt", sep = "", header = FALSE)


head(Xvalues)
head(Ylabels)


#Using the features read earlier to rename the columns of Xvalues :
names(Xvalues) <- features[ ,1] 
head(Xvalues)


#Extracting the mean and standard deviation 
Xvalues <- select (Xvalues, grep("std|mean", names(Xvalues), ignore.case = TRUE, fixed=FALSE) )


Ylabels <- merge(Ylabels, activity_labels, by.x = "V1", by.y = "V1")[2]
Xvalues <- cbind(Person, Ylabels, Xvalues)
names(Xvalues)[1:2] <- c("Person", "Activity")



#And finally, tidying the set Xvalues
#pipeline operator
Xvalues_tidy<- Xvalues %>% setNames(make.names(names(.), unique = TRUE)) %>% group_by(Person, Activity) %>% 
  summarize_each(funs(mean))


#write.table(Xvalues, file = "TidyData", append = FALSE, quote = TRUE, sep = " ",
#            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
#            col.names = TRUE, qmethod = c("escape", "double"),
#            fileEncoding = "")
View(Xvalues_tidy)



