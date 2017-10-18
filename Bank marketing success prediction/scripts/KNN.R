#KNN model is under construction
#install.packages("knncat")
library(knncat)

knn.train.labels <- trainingDataSet.clean.equal$y
knn.test.labels <- testingDataSet$y

knn.train<-trainingDataSet.clean.equal[1:1000,]
knn.test<-trainingDataSet.clean.equal[1:1000,]
for (i in 1:ncol(knn.train))
if(is.factor(knn.train[,i])){
  knn.train[,i]<-factor(knn.train[,i])
  knn.test[,i]<-factor(knn.test[,i])
}

knnModel <- knncat(knn.train,knn.test ,classcol=21)

