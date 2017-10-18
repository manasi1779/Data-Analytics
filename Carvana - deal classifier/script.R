trainingData = read.csv(file="training.csv", head=TRUE, sep=",")

#data = trainingData[-c(2)]
testData = read.csv(file="test.csv", head=TRUE, sep=",")
testData$IsBadBuy <- NA
totaldata = rbind(trainingData, testData)
library(reshape2)

totaldata$SubModel = trimws(totaldata$SubModel)

#totaldata = na.omit(totaldata)

for(index in 1:nrow(totaldata)){
  if(grepl("^[^0-9].*", totaldata$SubModel[index])){
    totaldata$SubModel[index] <- as.character(paste(NULL, totaldata$SubModel[index]))
  }
}

y<-colsplit(string=totaldata$SubModel, pattern=" ", names=c("Part1", "Part2"))

x$Part5 <- NA
for(index in 1:nrow(x)){
  x$Part3[index] <- gregexpr("[[:digit:]]+\\.[[:digit:]]+L",x$Part2[index])
}

for(index in 1:nrow(x)){
  if(as.numeric(x$Part3[index]) > 0){
    x$Part5[index] <- substr(x$Part2[index], x$Part3[index], (as.numeric(x$Part3[index]) + 2))
  }
}

x$Part2 = y$Part2
for(index in 1:nrow(x)){
  if(as.numeric(x$Part3[index]) > 0){
    x$Part2[index] <- paste(substr(x$Part2[index], 0, as.numeric(x$Part3[index]) - 1), substring(x$Part2[index], as.numeric(x$Part3[index]) +4))
  }
}
x$Part2 <- trimws(x$Part2)
x$Part4 <- as.numeric(x$Part5)

library(plyr)
t <- count(x, 'Part2')
attach(t)
t <- t[order(-freq),]
detach(t)

library(wordcloud) 
set.seed(142)   
wordcloud(t$Part2, t$freq, min.freq=500, rot.per=0.2, colors=brewer.pal(6, "Dark2"))

Z<ModelCleaner
ModelCleaner <- subset(totaldata, select=c('Model'))
ModelCleaner$Capacity <- NA
ModelCleaner$Part3 <- NA
ModelCleaner$Model <- gsub("-", "", ModelCleaner$Model)
ModelCleaner$Part4 = NA
ModelCleaner$Model <- gsub("\\s+"," ", ModelCleaner$Model)
ModelCleaner$Model <- gsub("V6 MFI V6", "V6 MFI", ModelCleaner$Model, perl=TRUE)
ModelCleaner$Model <- gsub("4C MFI V6", "V6 MFI", ModelCleaner$Model, perl=TRUE)
ModelCleaner$Model <- gsub("V6 V6", "V6", ModelCleaner$Model, perl=TRUE)
ModelCleaner$Model <- gsub("V8 V8", "V8", ModelCleaner$Model, perl=TRUE)

#Removing duplicates
ModelCleaner$Part4 <- gregexpr("/",ModelCleaner$Model)

for(index in 1:nrow(ModelCleaner)){
  if(as.numeric(ModelCleaner$Part4[index]) > 0){
    ModelCleaner$Model[index] <- substr(ModelCleaner$Model[index], 0, (as.numeric(ModelCleaner$Part4[index])-1))
  }
}

#Exctracting capacity
ModelCleaner$Part3 <- gregexpr("[[:digit:]]+\\.[[:digit:]]+L",ModelCleaner$Model)

for(index in 1:nrow(ModelCleaner)){
  if(ModelCleaner$Part3[index] > 0){
    ModelCleaner$Capacity[index] <- substr(ModelCleaner$Model[index], ModelCleaner$Part3[index], (as.numeric(ModelCleaner$Part3[index]) + 2))
    ModelCleaner$Model[index] <-paste(substr(ModelCleaner$Model[index], 0, as.numeric(ModelCleaner$Part3[index]) - 1), substring(ModelCleaner$Model[index], as.numeric(ModelCleaner$Part3[index]) +4))
  }
}

#Exctracting engine type
ModelCleaner$Engine = NA
ModelCleaner$Part5 <- gregexpr("4C|V6|V8|6C|5C",ModelCleaner$Model)
for(index in 1:nrow(ModelCleaner)){
  if(as.numeric(ModelCleaner$Part5[index])>0){
    ModelCleaner$Engine[index] <- substr(ModelCleaner$Model[index], ModelCleaner$Part5[index], (as.numeric(ModelCleaner$Part5[index]) + 2))
    ModelCleaner$Model[index] <-paste(substr(ModelCleaner$Model[index], 0, as.numeric(ModelCleaner$Part5[index]) - 1), substring(ModelCleaner$Model[index], as.numeric(ModelCleaner$Part5[index]) +3))
  }
}

#Exctracting wheel drive
ModelCleaner$WheelDrive = NA
ModelCleaner$Part6 = NA
ModelCleaner$Part6 <- gregexpr("AWD|2WD|4WD|FWD|RWD",ModelCleaner$Model)
for(index in 1:nrow(ModelCleaner)){
  if(as.numeric(ModelCleaner$Part6[index])>0){
    ModelCleaner$WheelDrive[index] <- substr(ModelCleaner$Model[index], ModelCleaner$Part6[index], (as.numeric(ModelCleaner$Part6[index]) + 2))
    ModelCleaner$Model[index] <-paste(substr(ModelCleaner$Model[index], 0, as.numeric(ModelCleaner$Part6[index]) - 1), substring(ModelCleaner$Model[index], as.numeric(ModelCleaner$Part6[index]) +4))
  }
}

modelFrequency <- count(ModelCleaner, 'Model')
attach(t)
modelFrequency <- modelFrequency[order(-freq),]
detach(t)
set.seed(142)   
wordcloud(modelFrequency$Model, modelFrequency$freq, max.words=200, colors=brewer.pal(6, "Dark2"))

totaldata$CleanedModel <- ModelCleaner$Model
totaldata$WheelDrive <- ModelCleaner$WheelDrive
totaldata$Engine <- ModelCleaner$Engine
totaldata$DoorType <- x$Part1
totaldata$CleanedSubModel <- x$Part2
totaldata$Capacity <- ModelCleaner$Capacity
t <- totaldata
cleanedTrainingData <- subset(totaldata, select=-c(Model, SubModel, RefId, VehYear, Auction, PurchDate, WheelTypeID, BYRNO))
cleanedTrainingData$Capacity <- x$Part5
ModelCleaner$Capacity<-as.numeric(ModelCleaner$Capacity)
for(index in 1:nrow(cleanedTrainingData)){
  if(is.na(cleanedTrainingData$Capacity[index]) && !is.na(ModelCleaner$Capacity[index])){
    cleanedTrainingData$Capacity[index] <- ModelCleaner$Capacity[index]
  }
}  
cleanedTrainingData$Trim <- toupper(cleanedTrainingData$Trim)
cleanedTrainingData$PRIMEUNIT <- as.character(cleanedTrainingData$PRIMEUNIT)
for(index in 1:nrow(cleanedTrainingData)){
  if(cleanedTrainingData$PRIMEUNIT[index]=='NULL'){
    cleanedTrainingData$PRIMEUNIT[index] = NA
  }
}
for(index in 1:nrow(cleanedTrainingData)){
  if(cleanedTrainingData$AUCGUART[index]=='NULL'){
    cleanedTrainingData$AUCGUART[index] = NA
  }
}
for(index in 1:nrow(cleanedTrainingData)){
  if(cleanedTrainingData$DoorType[index]==""){
    cleanedTrainingData$DoorType[index] = NA
  }
}
cleanedTrainingData <- subset(cleanedTrainingData, select=-c(VNZIP1))
write.csv(cleanedTrainingData, "cleanedData.csv")

cleanedTrainingData <- read.csv("cleanedData.csv")
cleanedTrainingData$Transmission <- toupper(cleanedTrainingData$Transmission)
cleanedTrainingData$WheelType <- toupper(cleanedTrainingData$WheelType)
nonNA <- subset(cleanedTrainingData   , !is.na(MMRAcquisitionAuctionCleanPrice) & WheelType != "" & Trim != "")

