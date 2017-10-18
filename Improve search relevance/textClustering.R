library(RCurl)
productTitles <- read.csv("train.csv", header = TRUE, sep = ",", quote = "\"")
nrow(productTitles)
length(unique(productTitles$product_title))
test<-read.csv("test.csv", header = TRUE, sep = ",", quote = "\"")

library(stringdist)
titles_small <- productTitles[1:20000,]
uniqueTitles <- unique(as.character(titles_small$product_title))
distanceTitles <- stringdistmatrix(uniqueTitles, uniqueTitles, method = "jw", maxDist = Inf, q = 1, p = 0, useNames = FALSE, ncores = 1, cluster = NULL)
rownames(distanceTitles)<-uniqueTitles
hc<-hclust(as.dist(distanceTitles))
#x<-identify(hc)

dfClust <- data.frame(uniqueTitles, cutree(hc, k=5))
names(dfClust) <- c('modelname','cluster')
print(paste('Average number of models per cluster:', mean(table(dfClust$cluster))))
t <- table(dfClust$cluster)
t <- cbind(t,t/length(dfClust$cluster))
t <- t[order(t[,2], decreasing=TRUE),]
p <- data.frame(factorName=rownames(t), binCount=t[,1], percentFound=t[,2])
dfClust <- merge(x=dfClust, y=p, by.x = 'cluster', by.y='factorName', all.x=T)
dfClust <- dfClust[rev(order(dfClust$binCount)),]
names(dfClust) <-  c('nameCluster','product_title','x','y')
head (dfClust[c('nameCluster','product_title')],5)
#clusplot(distanceTitles, distanceTitles$cluster, color=T, shade=T, labels=2, lines=0)

#pr<-predict(dfClust,test$search_term)

train<-read.csv(file="train.csv",head=TRUE,sep=",")
#unique(as.character(titles_small$product_title))
query <-  ("select nameCluster, unique(as.character(train$product_title) from dfClust")
queryTable <- sqldf(query)
print(colnames(queryTable))
print(colnames(train))
trainingData <- join(queryTable, train, by = "product_title", type = "inner", match = "all")

#titles_small <- productTitles[1:20000,]
uniqueTerms <- unique(as.character(titles_small$search_term))
distanceTerms <- stringdistmatrix(uniqueTerms, uniqueTerms, method = "lv", maxDist = Inf, q = 1, p = 0, useNames = FALSE, ncores = 1, cluster = NULL)
rownames(distanceTerms)<-uniqueTerms
hct<-hclust(as.dist(distanceTerms))

#x<-identify(hc)
termClust <- data.frame(uniqueTerms, cutree(hct, k=50))
names(termClust) <-  c('search_term','termCluster')
query <-  ("select termCluster, search_term from termClust")
queryTable <- sqldf(query)
trainingData <- join(trainingData, queryTable, by = "search_term", type = "inner", match = "all")
write.csv(file="clusered.csv", x=trainingData)
#newData <- SMOTE(relevance ~ ., trainingData, perc.over = 600,perc.under=100)
rf <- randomForest(relevance ~termCluster + nameCluster, data=trainingData, ntree=1000,keep.forest=TRUE, importance = TRUE)