library(tm)
library(ggplot2)
library(lsa)
library(rattle)

trainingData<-read.csv(file="train.csv",head=TRUE,sep=",")
rattle()

#cormat<-cor(trainingData)
#corrplot(cormat, Method = "circle")
