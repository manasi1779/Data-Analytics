install.packages("corrplot")
install.packages("mlearning")
install.packages("nnet")
install.packages("pROC")
install.packages("caret")
library(corrplot)
library(mlearning)
library(nnet)
library(pROC)
library(caret)

#Reading data from excel file and partitioning it into training and testing data
df = read.csv(file="IF1-FEB22-detailed.csv",head=TRUE,sep=",")
dssize <- floor(0.8 * nrow(df))
set.seed(123)
train_ind <- sample(seq_len(nrow(df)), size = dssize)
trainingData <- df[train_ind, ]
linearTrainingData <- trainingData[,c("Interfacial_Tension", "Year", "Total_Acid_Number", "Dissipation_Factor", "Colour")]
logisticTrainingData<-trainingData[,c("Year", "Total_Acid_Number", "Dissipation_Factor", "Colour", "Class")]
testData <- df[-train_ind, ]

#Creating Linear regression model
reg1<-lm(formula = Interfacial_Tension ~ Year+ Total_Acid_Number + Dissipation_Factor + Colour, data =  linearTrainingData)
summary(reg1)
plot(reg1)

#Verifying selected independent variables by viewing co-relation matrix
cormat<-cor(df[,-match(c("Class"),names(df))])
corrplot(cormat, Method = "circle")

#Creating logistic regression model
testData<-testData[,c("Year", "Total_Acid_Number", "Dissipation_Factor", "Colour", "Class")]
reg2<-multinom(Class ~ Year+ Total_Acid_Number + Dissipation_Factor + Colour, data =  logisticTrainingData)
predict <- predict(reg2, testData, "probs")
predict_Class <- predict (reg2, testData)
summary(predict_Class)

#Creating roc plot and Confusion matrix to verify logistic regression model
rocplot <- roc(Class ~ as.numeric(predict_Class), data = testData)
summary(rocplot)
plot(rocplot)
confusionMatrix(predict_Class, testData$Class)

