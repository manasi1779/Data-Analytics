NormalizedData <- RateData

for(x in 11:18){
  NormalizedData[,c(x)] <- round(rnorm(RateData[,c(x)]), 2)
}
for(x in 25:27){
  NormalizedData[,c(x)] <- round(rnorm(RateData[,c(x)]), 2)
}

NormalizedData$VehOdo <- round(rnorm(RateData$VehOdo), 2)
NormalizedData$VehBCost <- round(rnorm(RateData$VehBCost), 2)
NormalizedData$WarrantyCost <- round(rnorm(RateData$WarrantyCost), 2)
NormalizedData$VehicleAge <- round(rnorm(RateData$VehicleAge), 2)

library(mice)
md.pattern(NormalizedData)
library(VIM)
aggr_plot <- aggr(NormalizedData, col=c('navyblue','red'), numbers=TRUE, sortVars=TRUE, labels=names(nonNA), cex.axis=.7, gap=3, ylab=c("Histogram of missing data","Pattern"))


imputed <- NormalizedData
imputed<- kNN(data = NormalizedData, variable=c("DoorType"),k=5)
NormalizedData$DoorType <- imputed$DoorType
imputed <- kNN(data=NormalizedData,variable=c("Engine"), k=5) 
NormalizedData$Engine <- imputed$Engine

plot <- aggr(imputed, col=c('navyblue','yellow'), numbers=TRUE, sortVars=TRUE)

#Not required
"
for(x in 1:27){
  if(is.numeric(NormalizedData[,c(x)])){
    minimum = min(NormalizedData[,c(x)])
    if(minimum < 0)
    NormalizedData[,c(x)] <- NormalizedData[,c(x)] - minimum
  }
}
"