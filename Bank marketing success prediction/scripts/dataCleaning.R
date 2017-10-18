
#Replacing unknown  tuples with NA value in testing and training dataset
trainingDataSet$education[trainingDataSet$education=="unknown"]=NA
trainingDataSet$job[trainingDataSet$job=="unknown"]=NA
trainingDataSet$housing[trainingDataSet$housing=="unknown"]=NA
trainingDataSet$loan[trainingDataSet$loan=="unknown"]=NA

testingDataSet$education[testingDataSet$education=="unknown"]=NA
testingDataSet$job[testingDataSet$job=="unknown"]=NA
testingDataSet$housing[testingDataSet$housing=="unknown"]=NA
testingDataSet$loan[testingDataSet$loan=="unknown"]=NA

#levels(trainingDataSet$education)

#write.csv(trainingDataSet,file="finaltraining.csv",row.names = FALSE)

#analyzing missing values of categorical variables: education","loan","housing","job
trainingMissings<-trainingDataSet[,c("education","loan","housing","job")]
plot <- aggr(trainingMissings, col=c('navyblue','yellow'),
             numbers=TRUE, sortVars=TRUE)

str(trainingDataSet)

#selecting subset of highly correlated attributes to education as per correlation matrix
trainingDataSetKNN<-trainingDataSet[,c("education","y","previous","duration","age","previous","contact","cons.conf.idx","cons.price.idx","job","pdays","nr.employed","emp.var.rate","Inflation.Rate","Interest.Rate","Income.Tax","Year","euribor3m")]

#replacing NA of Eduction values with imputation using Knn method
imputedEdu<- kNN(trainingDataSetKNN,variable=c("education"),k=10)

plot <- aggr(imputedEdu, col=c('navyblue','yellow'), numbers=TRUE, sortVars=TRUE)

#Replacing Eduction value of training dataset with value received after imputation 

trainingDataSet$education<-imputedEdu$education
summary(imputedEdu)
str(imputedEdu)

#removing All rows containing NA values from training dataset
trainingDataSet.clean<- na.omit(trainingDataSet)


plot <- aggr(trainingDataSet.clean, col=c('navyblue','yellow'),
             numbers=TRUE, sortVars=TRUE)
#checking squeness of target variable in clean dataset
table(trainingDataSet.clean$y)



#perfroming upsampling and downsampling for minor and major class using SMOTE package

#install.packages("caret", dependencies = c("Depends", "Suggests"))
#
trainingDataSet.clean.equal<-SMOTE(y ~.,data=trainingDataSet.clean,perc.over = 100, perc.under = 200)
#checking squness in target variable
table(trainingDataSet.clean.equal$y)
#write.csv(trainingDataSet.clean.equal,file="cleanData.csv",row.names = FALSE)