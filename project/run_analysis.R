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

#Combine into one test set
testSet<-data.frame(subjectTest$Subject,testY$Activity,testX)
featureNames<-as.vector(features$Feature)
names(testSet)<-c("Subject","Activity",featureNames)
testAgg<-(aggregate(testSet,by=list(testSet$Subject,testSet$Activity),FUN=mean))

#Read in Training Data
subjectTrain<-read.csv("train/subject_train.txt",header=FALSE,col.names="Subject")
trainY<-read.csv("train/y_train.txt",header=FALSE,col.names="Activity")
trainX<-read.csv("train/X_train.txt",sep="",header=FALSE)

#Combine into one train set
trainSet<-data.frame(subjectTrain$Subject,trainY$Activity,trainX)
names(trainSet)<-c("Subject","Activity",featureNames)
trainAgg<-(aggregate(trainSet,by=list(trainSet$Subject,trainSet$Activity),FUN=mean))

#Combine training and test
dataSet<-rbind(trainSet,testSet)
#subjectSet<-rbind(subjectTest,subjectTrain)
dataSet$Activity[testY$Activity==1]<-"WALKING"
dataSet$Activity[testY$Activity==2]<-"WALKING_UPSTAIRS"
dataSet$Activity[testY$Activity==3]<-"WALKING_DOWNSTAIRS"
dataSet$Activity[testY$Activity==4]<-"SITTING"
dataSet$Activity[testY$Activity==5]<-"STANDING"
dataSet$Activity[testY$Activity==6]<-"LAYING"
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
#Combine subject means
sMeans<-rbind(testAgg,trainAgg)
drops <- c("Group.1","Group.2")
sMeans<-sMeans[,!(names(sMeans) %in% drops)]
osm<-sMeans[with(sMeans, order(Subject, Activity)), ]
osm$Activity[osm$Activity==1]<-"WALKING"
osm$Activity[osm$Activity==2]<-"WALKING_UPSTAIRS"
osm$Activity[osm$Activity==3]<-"WALKING_DOWNSTAIRS"
osm$Activity[osm$Activity==4]<-"SITTING"
osm$Activity[osm$Activity==5]<-"STANDING"
osm$Activity[osm$Activity==6]<-"LAYING"
write.csv(osm,file="tidy2.csv")