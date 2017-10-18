install.packages("randomForest")
require(randomForest)
library(randomForest)
library(caret)

#Separating into training data and Testing Data
clustered = read.csv(file="clustered.csv", head=TRUE, sep=",")
trainData <- clustered[0:20000,]
testData <- clustered[20000:40000,]
desired <- testData[,c(6)]
rf <- randomForest(relevance ~ nameCluster + termCluster, data=trainData, ntree=100,keep.forest=TRUE, importance = TRUE, do.trace=TRUE)
testData<-testData[,-c(6)]
testData <- testData[,colSums(is.na(derived)) == 0]
pr <- predict(rf, testData)
summary(pr)
summary(rf)

#confusion matrix for test data
cm <- confusionMatrix(desired, pr)