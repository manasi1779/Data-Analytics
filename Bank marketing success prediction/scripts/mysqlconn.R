bankData <-read.csv(file="finaltraining.csv",head=TRUE,sep=",")
bankData$clientID<-seq.int(nrow(bankData))
con = dbConnect(RSQLite::SQLite(), dbname="bankDB.db")
alltables = dbListTables(con)
dbListFields(con,"job")

Jobs<-as.data.table(unique(bankData[,c("job")]))
colnames(Jobs)<-"job"
Jobs$idjob<-seq.int(nrow(Jobs))
dbWriteTable(con, "job", Jobs, overwrite=TRUE)

education<-as.data.table(unique(bankData[,c("education")]))
colnames(education)<-"education"
education$ideducation<-seq.int(nrow(education))
dbWriteTable(con, "education", education, overwrite=TRUE)

contactType<-as.data.table(unique(bankData[,c("contact")]))
colnames(contactType)<-"contacttype"
contactType$idcontacttype <- seq.int(nrow(contacttype))
dbWriteTable(con, "contactType", contactType, overwrite=TRUE)

maritalstatus<-as.data.table(unique(bankData[,c("marital")]))
colnames(maritalstatus)<-"status"
maritalstatus$idmaritalstatus <- seq.int(nrow(maritalstatus))
dbWriteTable(con, "maritalstatus", maritalstatus, overwrite=TRUE)

incometax<-as.data.table(unique(bankData[,c("Year","Income.Tax")]))
dbWriteTable(con, "incometax", incometax, overwrite=TRUE)

economic_factor<-as.data.table(unique(bankData[,c("Year","Month","Inflation.Rate", "nr.employed", "emp.var.rate","cons.price.idx","cons.conf.idx")]))
dbWriteTable(con, "economic_factor", economic_factor, overwrite=TRUE)

client<-as.data.table(unique(bankData[,c("clientID","age","contact","marital","education","job")]))
#contactType$contacttype == client$contact
#client[contact %in% contactType[,contacttype]]
#client$contactId<-contactType[contactType$contacttype == client$contact, drop = FALSE]$idcontacttype
#client[contact==contactType$contacttype,idcontacttype:=contactType$idcontacttype]
#client$job<-Jobs[Jobs$job ==client$job,]$idjob
#client$education<-education[education$education==client$education,]$ideducation
#client$marital<-maritalstatus[maritalstatus$status==client$marital,]$idmaritalstatus
dbWriteTable(con, "client", client, overwrite=TRUE)

bank<-as.data.table(unique(bankData[,c("clientID", "housing","loan")]))
dbWriteTable(con, "bank", bank, overwrite=TRUE)

campaign<-as.data.table(unique(bankData[,c("clientID","previous","campaign","default","poutcome","day_of_week","duration","pdays","y","Month","Year","euribor3m")]))
dbWriteTable(con, "campaign", campaign, overwrite=TRUE)

rs <- dbSendQuery(db, "SELECT age FROM client")

