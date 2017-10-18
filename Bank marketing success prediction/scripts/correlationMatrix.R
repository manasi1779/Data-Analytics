#Reading data
bank.loan.customer.data = read.csv(file="bank-additional-full.csv",head=TRUE,sep=",")

#Verifying selected independent variables by viewing co-relation matrix

bank.loan.customer.data$cons.price.idx <- round_any(bank.loan.customer.data$cons.price.idx, accuracy = 0.01, f=floor)
bank.loan.customer.data$cons.price.idx<-gsub("[[:space:]]", "", bank.loan.customer.data$cons.price.idx)
bank.loan.customer.data$cons.price.idx <- as.numeric(bank.loan.customer.data$cons.price.idx)

#Reading new table created from http://www.tradingeconomics.com/analytics/api.aspx?source=chart
#CPI<-unique(bank.loan.customer.data[c("cons.price.idx")])
CPI.data<-read.csv(file="CPI.csv",head=TRUE,sep=",")
CPI.data$cons.price.idx<-as.numeric(CPI.data$cons.price.idx)

# Joining tables based on consumer price index 
bank.loan.customer.data<-join(bank.loan.customer.data,CPI.data, by = 'cons.price.idx', type = "left", match = "all")

bank.data.numeric<-bank.loan.customer.data
bank.data.numeric<-bank.data.numeric[complete.cases(bank.data.numeric),]
bank.data.numeric <- data.frame(lapply(bank.data.numeric, trimws))

#Converting required columns to numeric
for(i in 1:26){
    bank.data.numeric[,c(i)]=as.numeric(bank.data.numeric[,c(i)])
}

#Removing space from attribute values
bank.loan.customer.data$Month<-gsub("[[:space:]]", "", bank.loan.customer.data$Month)
bank.loan.customer.data$day_of_week<-gsub("[[:space:]]", "", bank.loan.customer.data$day_of_week)

for(i in 1:nrow(bank.data.numeric)){
  switch(bank.loan.customer.data[i,]$Month,
         Jan={
           bank.data.numeric[i,]$Month = 1     
         },
         Feb={
           bank.data.numeric[i,]$Month = 2     
         },
         Mar={
           bank.data.numeric[i,]$Month = 3     
         },
         Apr={
           bank.data.numeric[i,]$Month = 4     
         },
         May={
           bank.data.numeric[i,]$Month = 5     
         },
         Jun={
           bank.data.numeric[i,]$Month = 6     
         },
         Jul={
           bank.data.numeric[i,]$Month = 7     
         },
         Aug={
           bank.data.numeric[i,]$Month = 8     
         },
         Sep={
           bank.data.numeric[i,]$Month = 9     
         },
         Oct={
           bank.data.numeric[i,]$Month = 10     
         },
         Nov={
           bank.data.numeric[i,]$Month = 11     
         },
         Dec={
           bank.data.numeric[i,]$Month = 12     
         },{}
    
  )
}
for(i in 1:nrow(bank.data.numeric)){
  switch(bank.loan.customer.data[i,]$day_of_week,
         mon={
           bank.data.numeric[i,]$day_of_week = 1     
         },
         tue={
           bank.data.numeric[i,]$day_of_week = 2     
         },
         wed={
           bank.data.numeric[i,]$day_of_week = 3     
         },
         thu={
           bank.data.numeric[i,]$day_of_week = 4     
         },
         fri={
           bank.data.numeric[i,]$day_of_week = 5     
         },
         sat={
           bank.data.numeric[i,]$day_of_week = 6     
         },
         sun={
           bank.data.numeric[i,]$day_of_week = 7     
         },{}
  )
}

#creating subset of data
bank.data.numeric<-subset(bank.data.numeric, select =-c(month))

#creating correlation matrix
correlationMatrix <- cor(bank.data.numeric,method = c("pearson"))

#plotting correlation matrix
col1 <- colorRampPalette(c("#7F0000","red","#FF7F00","yellow","white", 
                           "cyan", "#007FFF", "blue","#00007F"))
correlationPlot<-corrplot(correlationMatrix, order='hclust',tl.cex = 0.7,tl.offset = 0.5,tl.col="black",method='square', col=col1(100))

