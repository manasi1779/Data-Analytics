#Prediction using random forest model

rf.test<-testingDataSet

#Creating vector of  target variable 
rf.label <- as.factor(trainingDataSet.clean.equal$y)
#Changing yes and no to 1 and 0 for making lable compatible to Random forest model
rf.label <- ifelse(rf.label=="yes", 1, 0)
str(rf.label)
table(rf.label)
rf.label<-factor(rf.label)

rf.train <- trainingDataSet.clean.equal
rf.train$y<-NULL
set.seed(1234)
rf <- randomForest(x = rf.train, y = rf.label, importance = TRUE, ntree = 1000)
rf
varImpPlot(rf)

Testing.knownOutput<-rf.test$y
rf.test$y<-NULL

#rf.test<- kNN(rf.test,k=10)
rf.y <- predict(rf, rf.test)
str(rf.y)
table(rf.y)
table(testingDataSet$y)
rf.actual <- ifelse(testingDataSet$y=="yes", 1, 0)
rf.actual<-factor(rf.actual)
cm = as.matrix(table(Actual = rf.actual, Predicted = rf.y))
cm

table(rf.actual)
auc <- roc(as.numeric(rf.actual),as.numeric( rf.y))
print(auc)
plot(auc,legacy.axes = TRUE)