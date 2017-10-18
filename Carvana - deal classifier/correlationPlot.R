library(corrplot)
correlationData <- subset(totaldata, select = -c(RefId, Auction, Make, Model, SubModel, WheelType, PRIMEUNIT, AUCGUART, BYRNO, VNST))
correlationData$Nationality <- as.numeric(correlationData$Nationality)
correlationData$Size <- as.numeric(correlationData$Size)
correlationData$Color <- as.numeric(correlationData$Color)
correlationData$Trim <- as.numeric(correlationData$Trim)
correlationData$PurchDate <- as.numeric(correlationData$PurchDate)
correlationData$Transmission <- as.numeric(correlationData$Transmission)
correlationData$TopThreeAmericanName <- as.numeric(correlationData$TopThreeAmericanName)
correlationData <- correlationData[!complete.cases(correlationData),]
cormat<-cor(correlationData, method="pearson")
col1 <- colorRampPalette(c("#7F0000","red","#FF7F00","yellow","white", 
                           "cyan", "#007FFF", "blue","#00007F"))
correlationPlot<-corrplot(cormat,tl.cex = 0.7,tl.offset = 0.5,tl.col="black",method='square', col=col1(100))

library(plotrix)
library(sqldf)
subset = sqldf("select count(RefId) as frequency from trainingData group by IsBadBuy")
statusTable <- trainingData$IsBadBuy
colors = c( "blue", "green")
pie(subset$frequency, col=colors)


#MMR estimates only:

for(x in 12:19){
  correlationData[,x] <- as.numeric(correlationData[,x])
}
mmrcor <- cor(correlationData[,12:19])
rownames(mmrcor) <- NULL
colnames(mmrcor) <- NULL
corrplot(mmrcor, tl.cex = 0.7,tl.offset = 0.5,tl.col="black")
