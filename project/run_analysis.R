library(reshape2)
setwd("/Users/pesto/Documents/school/Coursera/getting_and_cleaning_data/github/project/UCI HAR Dataset")

# Load in the names of the X data.
features<-read.csv("features.txt",sep=" ",header=FALSE,col.names=c("Feature.Index","Feature"))

# The names of the activities
activity_labels<-read.csv("activity_labels.txt",sep=" ",header=FALSE,col.names=c("Activity.Index","Activity.Label"))

# Load all Test Data
subjectTest<-read.csv("test/subject_test.txt",header=FALSE,col.names="Subject")
testY<-read.csv("test/y_test.txt",header=FALSE,col.names="Activity")
testX<-read.csv("test/X_test.txt",sep="",header=FALSE)
#names(testSet)<-c("Subject","Activity")
#Substitute Activity Names - Do this programatically if I have time
testY$Activity[testY$Activity==1]<-"WALKING"
testY$Activity[testY$Activity==2]<-"WALKING_UPSTAIRS"
testY$Activity[testY$Activity==3]<-"WALING_DOWNSTAIRS"
testY$Activity[testY$Activity==4]<-"SITTING"
testY$Activity[testY$Activity==5]<-"STANDING"
testY$Activity[testY$Activity==6]<-"LAYING"

#Combine into one test set
testSet<-data.frame(subjectTest$Subject,testY$Activity,testX)
featureNames<-as.vector(features$Feature)
names(testSet)<-c("Subject","Activity",featureNames)

#Read in Training Data
subjectTrain<-read.csv("train/subject_train.txt",header=FALSE,col.names="Subject")
trainY<-read.csv("train/y_train.txt",header=FALSE,col.names="Activity")
trainX<-read.csv("train/X_train.txt",sep="",header=FALSE)

#Substitute Activity Names - Do this programatically if I have time
trainY$Activity[trainY$Activity==1]<-"WALKING"
trainY$Activity[trainY$Activity==2]<-"WALKING_UPSTAIRS"
trainY$Activity[trainY$Activity==3]<-"WALING_DOWNSTAIRS"
trainY$Activity[trainY$Activity==4]<-"SITTING"
trainY$Activity[trainY$Activity==5]<-"STANDING"
trainY$Activity[trainY$Activity==6]<-"LAYING"

#Combine into one train set
trainSet<-data.frame(subjectTrain$Subject,trainY$Activity,trainX)
names(trainSet)<-c("Subject","Activity",featureNames)

#Combine training and test
dataSet<-rbind(trainSet,testSet)
#subjectSet<-rbind(subjectTest,subjectTrain)

# Subset the "mean" cols
fnd<-as.data.frame(featureNames)
fnd$fnd1<-as.vector(fnd$featureNames)
meanNames<-subset(fnd,grepl("mean",fnd$featureNames)==TRUE,select="featureNames")
mnV<-unlist(meanNames)
mnVa<-as.character(mnV)
meanSubset<-subset(dataSet,select=mnVa)
#colnames(meanSubset)
dataSet.mean<-cbind(dataSet$Subject,dataSet$Activity,meanSubset)


# Subset the "std dev" cols
#fnd<-as.data.frame(featureNames)
#fnd$fnd1<-as.vector(fnd$featureNames)
stdNames<-subset(fnd,grepl("std",fnd$featureNames)==TRUE,select="featureNames")
stdV<-unlist(stdNames)
stdVa<-as.character(stdV)
stdSubset<-subset(dataSet,select=stdVa)
#colnames(meanSubset)
#dataSet.std<-cbind(dataSet$Subject,dataSet$Activity,stdSubset)

dataSet.final<-cbind(dataSet.mean,stdSubset)
names(dataSet.final)[names(dataSet.final)=="dataSet$Subject"]<-"Subject"
names(dataSet.final)[names(dataSet.final)=="dataSet$Activity"]<-"Activity"
write.csv(dataSet.final,file="dataSet.final.csv")
#subset to calculate means
drops <- c("Subject","Activity")
ds.calc<-dataSet.final[,!(names(dataSet.final) %in% drops)]
dataSet.final<-cbind(dataSet.final,rowMeans(ds.calc))
dataSet.final<-rbind(dataSet.final,as.numeric(colMeans(ds.calc)))
names(dataSet.final)[names(dataSet.final)=="rowMeans(ds.calc"]<-"Means"

