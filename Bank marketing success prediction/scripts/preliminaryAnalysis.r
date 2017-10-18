#read data from CSV
completeDataset<-read.csv("bank-additional-full.csv",sep=",",header =TRUE )
str(completeDataset)
completeDataset$cons.price.idx <- round_any(completeDataset$cons.price.idx, accuracy = 0.01, f=floor)
completeDataset$cons.price.idx<-gsub("[[:space:]]", "", completeDataset$cons.price.idx)
completeDataset$cons.price.idx <- as.numeric(completeDataset$cons.price.idx)

CPI.data<-read.csv(file="CPI.csv",head=TRUE,sep=",")
CPI.data$cons.price.idx<-gsub("[[:space:]]", "", CPI.data$cons.price.idx)
CPI.data$cons.price.idx<-as.numeric(CPI.data$cons.price.idx)

# Joining tables based on consumer price index 
completeDataset<-join(completeDataset,CPI.data, by = "cons.price.idx", type = "left", match = "all")

# Investigating missing values for categorical variables
levels(completeDataset$job) #unknowns
levels(completeDataset$education) #unknows
levels(completeDataset$contact) #knows
levels(completeDataset$poutcome) #other unknown 
levels(completeDataset$housing)#unknown
levels(completeDataset$loan)#unknown
levels(completeDataset$poutcome)#know
levels(completeDataset$month)#know
levels(completeDataset$age)#know
completeDataset$age<-factor(completeDataset$age)

#dividing data in train and test dataset
set.seed(123)
trainSize <- ceiling(0.8 * nrow(completeDataset))
trainDataset_ind <- sample(seq_len(nrow(completeDataset)), size = trainSize)
trainingDataSet <- completeDataset[trainDataset_ind, ]
testingDataSet <- completeDataset[-trainDataset_ind, ]

#chi squre test for checking independence of target attribut with various attribute
#taken help from http://www.r-tutor.com/elementary-statistics/goodness-fit/chi-squared-test-independence
#while writing script

jobAndY=trainingDataSet[,c("job","y")]
levels(jobAndY$job) <- c("known", "known", "known","known","known","known","known", "known", "known","known","known","unknown")
contingencyTblJob = table(jobAndY$job, jobAndY$y) 
contingencyTblJob
chisq.test(contingencyTblJob) 

eduAndY=trainingDataSet[,c("education","y")]
levels(eduAndY$education) <- c("known", "known", "known","known", "known", "known","known","unknown")
contingencyTblEdu = table(eduAndY$education, eduAndY$y) 
contingencyTblEdu
chisq.test(contingencyTblEdu) 

marAndY=trainingDataSet[,c("marital","y")]
levels(marAndY$marital) <- c("known", "known","known","unknown")
contingencyTblMar = table(marAndY$marital, marAndY$y) 
contingencyTblMar
chisq.test(contingencyTblMar) 

houseAndY=trainingDataSet[,c("housing","y")]
levels(houseAndY$housing) <- c("known", "unknown","known")
contingencyTblhouse = table(houseAndY$housing, houseAndY$y) 
contingencyTblhouse
chisq.test(contingencyTblhouse) 

dfy<-trainingDataSet$y
dfy.Ysub<-subset(dfy,dfy=="yes")
dfy.Ysub<-factor(dfy.Ysub)
dfy.Nsub<-subset(dfy,dfy=="no")
dfy.Nsub<-factor(dfy.Nsub)
chidf <- data.frame(
  chivariable = c("Yes", "No"),
  chivalue = c(length(dfy.Ysub), length(dfy.Nsub))
)

loanAndY=trainingDataSet[,c("loan","y")]
levels(loanAndY$loan) <- c("known", "unknown","known")
contingencyTblloan = table(loanAndY$loan, loanAndY$y) 
contingencyTblloan
chisq.test(contingencyTblloan) 

# checking squeness 

dev.off()
### below code for plot is inspired from http://docs.ggplot2.org/current/coord_polar.html
ggplot(dfchi, aes(x = "", y = chivalue, fill = chivariable)) +
  geom_bar(width = 1, stat = "identity") +
  scale_fill_manual(chivalues = c("red", "green")) +
  coord_polar("y", start = pi / 3) +
  labs(title = "y")
#######################################

#Data Analysis
#below code is inspired form http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/
ggplot(completeset, aes(x = job, fill = y)) +  geom_bar()
ggplot(trainingDataSet, aes(x = education, fill = y)) +  geom_bar()
ggplot(completeset, aes(x = day_of_week, fill = y)) +  geom_bar()
completeset$campaign <- factor(completeset$campaign)
ggplot(completeset, aes(x = campaign, fill = y)) +  geom_bar()
completeset$age <- factor(completeset$age)
ggplot(completeset, aes(x = age, fill = y)) +  geom_bar()
ggplot(completeset, aes(x = housing, fill = y)) +  geom_bar()
ggplot(completeset, aes(x = loan, fill = y)) +  geom_bar()
ggplot(completeset, aes(x = marital, fill = y)) +  geom_bar()
str(completeset)
ggplot(completeset, aes(x = month, fill = y)) +  geom_bar()
str(completeset)
ggplot(completeset, aes(x = default, fill = y)) +  geom_bar()
ggplot(completeset, aes(x = contact, fill = y)) +  geom_bar()
completeset$pdays <- factor(completeset$pdays)
completeset$cons.price.idx <- factor(completeset$cons.price.idx)
completeset$nr.employed <- factor(completeset$nr.employed)
completeset$cons.conf.idx <- factor(completeset$cons.conf.idx)
completeset$emp.var.rate <- factor(completeset$emp.var.rate)
str(completeset)
ggplot(completeset, aes(x = pdays, fill = y)) +  geom_bar()
ggplot(completeset, aes(x = cons.price.idx, fill = y)) +  geom_bar()
ggplot(completeset, aes(x = cons.conf.idx, fill = y)) +  geom_bar()
ggplot(completeset, aes(x = nr.employed, fill = y)) +  geom_bar()
ggplot(completeset, aes(x = emp.var.rate, fill = y)) +  geom_bar()
str(completeset)
completeset$previous <- factor(completeset$previous)
ggplot(completeset, aes(x = previous, fill = y)) +  geom_bar()















