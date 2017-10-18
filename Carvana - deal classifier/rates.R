library(plyr)
library(caret)
library(MASS)
library(DMwR)

trainingDataSet.clean.equal <- subset(FinalTrainingSet, select=-c(PRIMEUNIT, AUCGUART, X))
trainingDataSet.clean.equal$IsBadBuy <- as.factor(trainingDataSet.clean.equal$IsBadBuy)

for(index in 1:ncol(trainingDataSet.clean.equal)){
  if(is.character(trainingDataSet.clean.equal[,c(index)])){
    trainingDataSet.clean.equal[,c(index)] <- as.factor(trainingDataSet.clean.equal[,c(index)])
  }
}

trainingDataSet.clean.equal<-SMOTE(IsBadBuy ~.,data=trainingDataSet.clean.equal)

rownames(trainingDataSet.clean.equal) <- NULL

cleanEqualData <- trainingDataSet.clean.equal

library(ftable)
library(reshape2)

CleanedModelFrequency <- NA
for(index in 1:ncol(cleanEqualData)){
    cleanEqualData[,c(index)] <- trimws(cleanEqualData[,c(index)])
}

CleanedModelFrequency <- table(cleanEqualData$CleanedModel, cleanEqualData$IsBadBuy)
CleanedModelFrequency <- ftable(CleanedModelFrequency)
probabilityTable <- as.data.table(prop.table(CleanedModelFrequency, 1))
endIndex  = nrow(probabilityTable)/2
probabilityTable <- probabilityTable[1:endIndex,]
names(probabilityTable)[1] <- paste("CleanedModel")
names(probabilityTable)[3] <- paste("ModelIsBadRate")
cleanEqualDataNew <- merge(x = cleanEqualData, y = probabilityTable, by = "CleanedModel", all = TRUE)

CleanedSubModelFrequency <- table(cleanEqualData$CleanedSubModel, cleanEqualData$IsBadBuy)
CleanedSubModelFrequency <- ftable(CleanedSubModelFrequency)
probabilityTable <- as.data.table(prop.table(CleanedSubModelFrequency, 1))
endIndex  = nrow(probabilityTable)/2
probabilityTable <- probabilityTable[1:endIndex,]
names(probabilityTable)[1] <- paste("CleanedSubModel")
names(probabilityTable)[3] <- paste("SubModelIsBadRate")
cleanEqualDataNew <- merge(x = cleanEqualDataNew, y = probabilityTable, by = "CleanedSubModel", all = TRUE)

TrimFrequency <- table(cleanEqualData$Trim, cleanEqualData$IsBadBuy)
TrimFrequency <- ftable(TrimFrequency)
probabilityTable <- as.data.table(prop.table(TrimFrequency, 1))
endIndex  = nrow(probabilityTable)/2
probabilityTable <- probabilityTable[1:endIndex,]
names(probabilityTable)[1] <- paste("Trim")
names(probabilityTable)[3] <- paste("TrimIsBadRate")
cleanEqualDataNew <- merge(x = cleanEqualDataNew, y = probabilityTable, by = "Trim", all = TRUE)

RateData <- subset(cleanEqualDataNew, select = -c(CleanedModel, CleanedSubModel, Trim, Var2.x, Var2.y,Var2))

