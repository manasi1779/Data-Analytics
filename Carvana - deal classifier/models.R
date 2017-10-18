
NormalizedData$IsOnlineSale <- as.numeric(NormalizedData$IsOnlineSale)
NormalizedData$IsOnlineSale <- round(NormalizedData$IsOnlineSale)
NormalizedData$IsBadBuy <- factor(NormalizedData$IsBadBuy)
  
for(x in 1:27){
  if(is.character(NormalizedData[,c(x)])){
      NormalizedData[,c(x)] <- as.factor(NormalizedData[,c(x)])
  }
}

library('caret')
df2 = cor(NormalizedData[11:18])
hc = findCorrelation(df2, cutoff=0.3)
hc = sort(hc)
reduced_Data = NormalizedData[,-c(hc)]
library(corrplot)

rownames(df2) <- NULL
colnames(df2) <- NULL
corrplot(df2, method = 'circle')

#dividing data in train and test dataset
set.seed(123)
trainSize <- ceiling(0.8 * nrow(NormalizedData))
trainDataset_ind <- sample(seq_len(nrow(NormalizedData)), size = trainSize)
trainingDataSet <- NormalizedData[trainDataset_ind, ]
testingDataSet <- NormalizedData[-trainDataset_ind, ]
expected<-testingDataSet$IsBadBuy
rownames(expected) <- NULL

#RandomForest
library(randomForest)
rf <- randomForest(IsBadBuy~., data = subset(trainingDataSet, select = -c(Engine, VNST)), ntree=100,keep.forest=TRUE, importance = TRUE, do.trace=TRUE)
testResult <- predict(rf,subset(testingDataSet, select=-c(IsBadBuy)) )
rownames(testResult) <- NULL
testResult <- as.numeric(testResult)
rf.pred.mat <- roc(expected,testResult)
rf.pred.mat
plot(rf.pred.mat)

library(caret)
RandomForestcm<-confusionMatrix(expected,testResult)
print(RandomForestcm)
plot <- ggplot(as.data.frame(RandomForestcm$table))
plot + geom_tile(aes(x=Prediction, y=Reference,fill=Freq)) + scale_x_discrete(name="Actual Class") + scale_y_discrete(name="Predicted Class") + scale_fill_gradient(breaks=seq(from=-.5, to=4, by=.2)) + labs(fill="Normalized\nFrequency")


#Decision Tree
plot(pred.mat)
decisionTreeCM <- confusionMatrix(expected,rs$outcome)
print(decisionTreeCM)
plot <- ggplot(as.data.frame(decisionTreeCM$table))
plot + geom_tile(aes(x=Prediction, y=Reference,fill=Freq)) + scale_x_discrete(name="Actual Class") + scale_y_discrete(name="Predicted Class") + scale_fill_gradient(breaks=seq(from=-.5, to=4, by=.2)) + labs(fill="Normalized\nFrequency")

#Naive Bayes

library(e1071)
NaiveBayelModel <- naiveBayes(IsBadBuy~., subset(trainingDataSet, select = -c(Engine, VNST)))
NaiveBayesPrediction <- predict(NaiveBayelModel, testingDataSet, type="class", probability = TRUE)
rownames(NaiveBayesPrediction) <- NULL


nb.pred.mat <- roc(expected, as.numeric(NaiveBayesPrediction))
plot(nb.pred.mat)

library(caret)
NaiveBayescm<-confusionMatrix(expected,NaiveBayesPrediction)
print(NaiveBayescm)
plot <- ggplot(as.data.frame(NaiveBayescm$table))
plot + geom_tile(aes(x=Prediction, y=Reference,fill=Freq)) + scale_x_discrete(name="Actual Class") + scale_y_discrete(name="Predicted Class") + scale_fill_gradient(breaks=seq(from=-.5, to=4, by=.2)) + labs(fill="Normalized\nFrequency")

#SVM Model
SVM_Model <- svm(IsBadBuy~., subset(trainingDataSet, select = -c(Engine, VNST)))
SVMPrediction <- predict(SVM_Model, testingDataSet)
rownames(SVMPrediction) <- NULL

svm.pred.mat <- roc(expected, as.numeric(SVMPrediction))
plot(svm.pred.mat)

library(caret)
library(ggplot2)
SVMcm<-confusionMatrix(expected,SVMPrediction)
print(SVMcm)
plot <- ggplot(as.data.frame(SVMcm$table))
plot + geom_tile(aes(x=Prediction, y=Reference,fill=Freq)) + scale_x_discrete(name="Actual Class") + scale_y_discrete(name="Predicted Class") + scale_fill_gradient(breaks=seq(from=-.5, to=4, by=.2)) + labs(fill="Normalized\nFrequency")

#Logistic regression
library(nnet)
reg2<-multinom(IsBadBuy~., subset(trainingDataSet, select = -c(Engine, VNST)))
logisticPredict<-predict(reg2, testingDataSet)
logisticPredict<-as.data.frame(logisticPredict)
logisticCM <-confusionMatrix(expected,logisticPredict$logisticPredict)
lm.pred.mat <- roc(expected, as.numeric(logisticPredict$logisticPredict))
plot(lm.pred.mat)
print(logisticCM)
plot <- ggplot(as.data.frame(logisticCM$table))
plot + geom_tile(aes(x=Prediction, y=Reference,fill=Freq)) + scale_x_discrete(name="Actual Class") + scale_y_discrete(name="Predicted Class") + scale_fill_gradient(breaks=seq(from=-.5, to=4, by=.2)) + labs(fill="Normalized\nFrequency")

#K nearest Neighbors
require(caret)

#Perform 10 fold cross validation
library(class)
library(data.table)
NumericCleanEqualDataNew <- NA
CleanedModelFrequency <- table(NumericNormalizedData$Make, NumericNormalizedData$IsBadBuy)
CleanedModelFrequency <- ftable(CleanedModelFrequency)
probabilityTable <- as.data.table(prop.table(CleanedModelFrequency, 1))
endIndex  = nrow(probabilityTable)/2
probabilityTable <- probabilityTable[1:endIndex,]
names(probabilityTable)[1] <- paste("Make")
names(probabilityTable)[3] <- paste("MakeIsBadRate")
NumericCleanEqualDataNew <- merge(x = NumericNormalizedData, y = probabilityTable, by = "Make", all = TRUE)

CleanedModelFrequency <- table(NumericNormalizedData$VNST, NumericNormalizedData$IsBadBuy)
CleanedModelFrequency <- ftable(CleanedModelFrequency)
probabilityTable <- as.data.table(prop.table(CleanedModelFrequency, 1))
endIndex  = nrow(probabilityTable)/2
probabilityTable <- probabilityTable[1:endIndex,]
names(probabilityTable)[1] <- paste("VNST")
names(probabilityTable)[3] <- paste("StateIsBadRate")
NumericCleanEqualDataNew <- merge(x = NumericCleanEqualDataNew, y = probabilityTable, by = "VNST", all = TRUE)
NumericCleanEqualDataNew$Make <- round(rnorm(NumericCleanEqualDataNew$MakeIsBadRate), 2)
NumericCleanEqualDataNew$VNST <- round(rnorm(NumericCleanEqualDataNew$StateIsBadRate), 2)
kNNTrainingData <- subset(NumericCleanEqualDataNew, select=-c(MakeIsBadRate, StateIsBadRate, Var2.x, Var2.y, Engine, DoorType, Size))

#Create 10 equally size folds
folds <- cut(seq(1,nrow(kNNTrainingData)),breaks=10,labels=FALSE)

performance = vector(,10)

for(fold in 1:10){
  #Segement your data by fold using the which() function 
  testIndexes <- which(folds==fold,arr.ind=TRUE)
  testData <- kNNTrainingData[testIndexes, ]
  trainData <- kNNTrainingData[-testIndexes, ]
  #Use the test and train data partitions however you desire...
  for(k in 1:10){
  expectedKnn <- testData$IsBadBuy
  actualResult <- knn(subset(trainData, select=-c(IsBadBuy)), subset(testData,select=-c(IsBadBuy)), trainData$IsBadBuy, k=k)
  knnCM <-confusionMatrix(expectedKnn,actualResult)
  performance[k] = performance[k] + knnCM$byClass[4]
  }
}
print(max(performance))
