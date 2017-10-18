library(MASS)

library(randomForest)
rf <- randomForest(IsBadBuy~., data = FinalTrainingSet, ntree=1000,keep.forest=TRUE, importance = TRUE)

NormalizedData <- FinalTrainingSet

for(x in 13:20){
  NormalizedData[,c(x)] <- rnorm(NormalizedData[,c(x)])
  NormalizedData[,c(x)] <- round(NormalizedData[,c(x)],2)
}

NormalizedData$VehOdo <- round(rnorm(NormalizedData$VehOdo), 2)
NormalizedData$VehBCost <- round(rnorm(NormalizedData$VehBCost), 2)
NormalizedData$WarrantyCost <- round(rnorm(NormalizedData$WarrantyCost), 2)

NormalizedTestData <- FinalTestSet
for(x in 13:20){
  NormalizedTestData[,c(x)] <- round(rnorm(NormalizedTestData[,c(x)]), 2)
}

NormalizedTestData$VehOdo <- round(rnorm(NormalizedTestData$VehOdo), 2)
NormalizedTestData$VehBCost <- round(rnorm(NormalizedTestData$VehBCost), 2)
NormalizedTestData$WarrantyCost <- round(rnorm(NormalizedTestData$WarrantyCost), 2)

NormalizedData <- subset(NormalizedData, select=-c(Trim))
NormalizedTestData <- subset(NormalizedTestData, select=-c(Trim))

trainingDataSet.clean.equal<-SMOTE(y ~.,data=trainingDataSet.clean,perc.over = 100, perc.under = 200)


lm.fit <- glm(IsBadBuy~., data=NormalizedData)
pr.lm <- predict(lm.fit,NormalizedTestData)
