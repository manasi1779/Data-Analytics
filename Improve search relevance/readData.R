	install.packages("plyr")
library("plyr")
require(stats)

#Combining traing data with attribute data
attributes<-read.csv(file="attributes.csv",head=TRUE,sep=",")
train<-read.csv(file="train.csv",head=TRUE,sep=",")
products<-unique(train[c("product_title")])
derived<-read.csv(file="derived.csv",head=TRUE,sep=",",na.strings=c("", "NA"),row.names=NULL)
colnames(derived) <- c(colnames(derived)[-1],"x")
derived$x <- NULL
derived[!(is.na(derived$product_uid) | derived$product_uid==""), ]
derived <- unique(derived, incomparables = FALSE, fromLast = FALSE)

#Removing index column
train<-train[,-c(1)]
derived[complete.cases(derived[,c(1)]),] 
trainingData <- join(train, derived, by = 'product_uid', type = "inner", match = "all")
newData <- subset(trainingData, select = -c(1))