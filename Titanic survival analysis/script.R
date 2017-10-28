install.packages("corrplot")
install.packages("nnet")
install.packages("pROC")
install.packages("caret")
install.packages("randomForest")
require(randomForest)
library(randomForest)
library(rpart.plot)
library(RColorBrewer)
library(party)					# Alternative decision tree algorithm
library(partykit)
library(rattle)					# Fancy tree plot
library(caret)					# Just a data source for this script
library(corrplot)
library(pROC)
library(zoo)
library(rpart)
library(ggplot2)
library(nnet)
library(stringr)

#Read the training data
titanic.data.train = read.csv(file="train.csv",head=TRUE,sep=",")

#Clean training data
titanic.data.train[c('Age')]<-na.aggregate(titanic.data.train[c('Age')])

#Convert categorical data to numeric for finding correlation
titanic.data.numeric <-titanic.data.train
titanic.data.numeric$Sex = as.numeric(titanic.data.train$Sex)
titanic.data.numeric$Embarked = as.numeric(titanic.data.train$Embarked)

#Ignore variables like name, PassengerId, Ticket which are not relevant and attribute Cabin has lot of missing values
titanic.data.train.subset<-subset(titanic.data.numeric, select=-c(PassengerId,Name,Ticket,Cabin))
cormat<-cor(titanic.data.train.subset, method = c("pearson"))
corrplot(cormat,method = "circle")

#Linear regression model
linearModel<-lm(formula=Survived~Sex+Fare+Age+Pclass+SibSp+Parch, data=titanic.data.train.subset)
testData.predict<-predict(lm,testData.subset)
summary(linearModel)
plot(linearModel)

#Adding new attribute sal~title
titanic.data.train$sal<-titanic.data.train.subset$Sex
for(i in 1:nrow(titanic.data.train)){
  row<-titanic.data.train[i,]
  if(str_detect(row$Name,"Mrs.")){
    titanic.data.train[i,]$sal<-1
    }
  else if(str_detect(row$Name,"Mr.")){
    titanic.data.train[i,]$sal<-0
    }
  else if(str_detect(row$Name,"Master.")){
    titanic.data.train[i,]$sal<-2
    }
  else if(str_detect(row$Name,"Miss.")){
    titanic.data.train[i,]$sal<-3
    }
  else if(str_detect(row$Name,"Ms.")){
    titanic.data.train[i,]$sal<-3
  }
  else if(row$Age<18 & row$Sex == 0){
    titanic.data.train[i,]$sal<-2
  }
  else if(row$Age<18 & row$Sex == 1){
    titanic.data.train[i,]$sal<-3
  }
}
titanic.data.numeric$sal<-titanic.data.train$sal

#Converting some numeric variables to categorical so that they are not considered as continuous variables
titanic.data.train$Survived<-cut(titanic.data.train$Survived,breaks=c(-1,0,1),labels=c("No","Yes"))
titanic.data.train$Sex<-cut(titanic.data.train$Sex,breaks=c(0,1,2),labels=c("Female","Male"))
titanic.data.train$sal<-cut(titanic.data.train$sal,breaks=c(-1,0,1,2,3),labels=c("Mr","Mrs","Master","Miss"))
titanic.data.train$Pclass<-cut(titanic.data.train$Pclass,breaks=c(0,1,2,3),labels=c("First","Second","Third"))

#Adding new attribute Fsize~family size
titanic.data.train<-data.frame(Fsize=rep("0",nrow(titanic.data.train)),titanic.data.train[,])
titanic.data.train$Fsize<-titanic.data.train$SibSp+titanic.data.train$Parch+1
titanic.data.numeric$Fsize<-titanic.data.train$Fsize

#Creating final correlation matrix using original and derived attributes
titanic.data.train.subset<-subset(titanic.data.numeric, select=-c(PassengerId,Name,Ticket,Cabin))
cormat<-cor(titanic.data.train.subset, method = c("pearson"))
corrplot(cormat,method = "circle")

#Creating decision tree model 
decisionTree<-rpart(Survived~., data=titanic.data.train.subset, method='class')
summary(decisionTree)
prp(decisionTree)
fancyRpartPlot(decisionTree)
titanic.rf <- randomForest(Survived ~ ., data=titanic.data.train.subset, ntree=750,keep.forest=TRUE, importance = TRUE, do.trace=TRUE)


#titanic.data.train<-data.frame(CabinClass=rep("0",nrow(titanic.data.train)),titanic.data.train[,])
#titanic.data.train$CabinClass<-

titleplot<-ggplot(titanic.data.train,aes(x=titanic.data.train$sal, fill=factor(titanic.data.train$Survived)))+
  stat_count(width=0.5)+
  xlab("Title")+
  ylab("Number of Passengers")+
  labs(fill="Survived")

fsizePlot<-ggplot(titanic.data.train,aes(x=titanic.data.train$Fsize, fill=factor(titanic.data.train$Survived)))+
  stat_count(width=0.5)+
  xlab("Family Size")+
  ylab("Number of Passengers")+
  labs(fill="Survived")

finalData<-subset(titanic.data.train, select=-c(PassengerId,Name,Ticket,Cabin,Age,SibSp,Parch,Embarked,Fsize))

#creating new decision tree model
newDecisionTree<-rpart(Survived~., data=finalData, method='class')
summary(newDecisionTree)
prp(newDecisionTree)
fancyRpartPlot(newDecisionTree)

testData<-read.csv(file="test.csv",head=TRUE,sep=",")
testData[c('Age')]<-na.aggregate(testData[c('Age')])
testData.numeric<-testData
testData.numeric$Sex = as.numeric(testData$Sex)
testData.numeric$Title<-testData.numeric$Sex
for(i in 1:nrow(testData.numeric)){
  row<-testData.numeric[i,]
  if(str_detect(row$Name,"Mrs.")){
    testData.numeric[i,]$Title<-1
  }
  else if(str_detect(row$Name,"Mr.")){
    testData.numeric[i,]$Title<-2
  }
  else if(str_detect(row$Name,"Master.")){
    testData.numeric[i,]$Title<-3
  }
  else if(str_detect(row$Name,"Miss.")){
    testData.numeric[i,]$Title<-4
  }
  else if(str_detect(row$Name,"Ms.")){
    testData.numeric[i,]$Title<-4
  }
  else if(row$Age<18 & row$Sex == 2){
    testData.numeric[i,]$Title<-3
  }
  else if(row$Age<18 & row$Sex == 1){
    testData.numeric[i,]$Title<-4
  }
}

#Formatting test data to fit in model
testData$Pclass<-cut(testData$Pclass,breaks=c(0,1,2,3),labels=c("First","Second","Third"))
testData$sal<-cut(testData.numeric$Title,breaks=c(0,1,2,3,4),labels=c("Mr","Mrs","Master","Miss"))
testData.subset<-subset(testData, select=-c(PassengerId,Name, SibSp, Parch,Cabin,Ticket,Embarked))

#Predict outcomes for testdata using decision tree converting probabilistic outcomes to categorical
testData.survival<-predict(newDecisionTree,testData.subset,type="prob")
rs<-as.data.frame(testData.survival)
for(i in 1:nrow(rs)){
  rs$outcome <-ifelse(rs$Yes > rs$No, 1, 0)
}

#Extracting outcomes for test data
testResult<-read.csv(file="gendermodel.csv",head=TRUE,sep=",")
#Creating comfusion matrix 
expected<-subset(testResult,select=-c(PassengerId))
cm<-confusionMatrix(expected$Survived,rs$outcome)

#Writing outcomes for test data obtained from model in to CSV
outputTable<-testResult
outputTable$Survived<-rs$outcome
write.table(outputTable, "ManasiBharde.csv",sep=",",row.names=FALSE)

expected$Survived<-cut(expected$Survived,breaks=c(-1,0,1),labels=c("No","Yes"))

#Creating random forest model
newRF<-randomForest(Survived~., data=finalData, ntree=100,keep.forest=TRUE, importance = TRUE, do.trace=TRUE)

#predicting outcomes for test data and creating confusion matrix
newPredict<-predict(newRF,testData.subset)
x<-as.data.frame(newPredict)
newCM<-confusionMatrix(expected$Survived,newPredict)
newCM

#Creating logistic regression model
reg2<-multinom(Survived ~ ., data = finalData)
logisticPredict<-predict(reg2, testData.subset)
logisticPredict<-as.data.frame(logisticPredict)
logisticCM <-confusionMatrix(expected$Survived,logisticPredict$logisticPredict)
outputTable<-testResult
for(i in 1:nrow(outputTable)){
  outputTable$Survived <-ifelse(logisticPredict$logisticPredict == "Yes", 1, 0)
}
#outputTable$Survived<-logisticPredict$logisticPredict
write.table(outputTable, "ManasiBharde.csv",sep=",",row.names=FALSE)
