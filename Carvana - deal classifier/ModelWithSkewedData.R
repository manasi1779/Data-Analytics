skewedData <- subset(FinalTrainingSet, select=-c(PRIMEUNIT, AUCGUART, X))
skewedData$IsBadBuy <- as.factor(skewedData$IsBadBuy)

for(index in 1:ncol(skewedData)){
  if(is.character(skewedData[,c(index)])){
    skewedData[,c(index)] <- as.factor(skewedData[,c(index)])
  }
}
for(x in 12:19){
  skewedData[,c(x)] <- round(rnorm(skewedData[,c(x)]), 2)
}
skewedData$VehOdo <- round(rnorm(skewedData$VehOdo), 2)
skewedData$VehBCost <- round(rnorm(skewedData$VehBCost), 2)
skewedData$WarrantyCost <- round(rnorm(skewedData$WarrantyCost), 2)
skewedData$VehicleAge <- round(rnorm(skewedData$VehicleAge), 2)

set.seed(123)
skewedtrainSize <- ceiling(0.8 * nrow(skewedData))
skewedtrainDataset_ind <- sample(seq_len(nrow(skewedData)), size = skewedtrainSize)
skewedtrainingDataSet <- skewedData[skewedtrainDataset_ind, ]
skewedtestingDataSet <- skewedData[-skewedtrainDataset_ind, ]
skewedexpected<-skewedtestingDataSet$IsBadBuy


library(randomForest)
skewedrf <- randomForest(IsBadBuy~., data = subset(skewedtrainingDataSet, select = -c(Engine, VNST, CleanedModel, CleanedSubModel, Trim, DoorType)), ntree=100,keep.forest=TRUE, importance = TRUE, do.trace=TRUE)
skewedtestResult <- predict(skewedrf, subset(subset(skewedtestingDataSet, select = -c(Engine, VNST, CleanedModel, CleanedSubModel, Trim, DoorType)), select=-c(IsBadBuy)) )
rownames(skewedtestResult) <- NULL

library(caret)
skewedRandomForestcm<-confusionMatrix(skewedexpected,skewedtestResult)
print(skewedRandomForestcm)
library(ggplot2)
plot <- ggplot(as.data.frame(skewedRandomForestcm$table))
plot + geom_tile(aes(x=Prediction, y=Reference,fill=Freq)) + scale_x_discrete(name="Actual Class") + scale_y_discrete(name="Predicted Class") + scale_fill_gradient(breaks=seq(from=-.5, to=4, by=.2)) + labs(fill="Normalized\nFrequency")
