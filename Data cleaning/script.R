library(sqldf)
library(ggplot2)
library(gender)

studentData = read.csv(file="Quiz_01_Responses_for_Release_Somewhat_Cleaned.csv",header = TRUE, sep = ",")
studentData <- data.frame(lapply(studentData, trimws))

noOfColorSpace <-as.data.frame((unique(studentData[,c("NAMESPACE.COLOR")])))
colnames(noOfColorSpace) <-"colorspaces"
AllColorSpaces = list('Orange', 'Pink', 'Brown', 'Red', 'Green', 'Blue', 'Yellow', 'Magenta', 'Cyan', 'White', 'Gray', 'Black')
#length(noOfColorSpace$colorspaces)

# 0R rule for choosing namespace color by taking random guess
professorsChoice <- AllColorSpaces[sample(1:12, 1)]
professorsChoice

# rule by taking majority
tail(names(sort(table(studentData$NAMESPACE.COLOR))), 1)
pie <- ggplot(studentData, aes(x = factor(1), fill = factor(NAMESPACE.COLOR))) +
  geom_bar(width = 1)
pie + coord_polar(theta = "y")

leftHanded = "select count([UNIQUE.ID]) as leftHanded from studentData where [LEFT.HANDED] = 'TRUE'"
leftHandedCount = sqldf(leftHanded)
leftHandedPercent = leftHandedCount/(length(studentData$LEFT.HANDED)-leftHandedCount)

polydactyl = "select [UNIQUE.ID] as polydactylID from studentData where POLYDACTYL='TRUE'"
polydactylPeople = sqldf(polydactyl) 

#There is no pattern in lower case answers
studentData$Fiction.Question = tolower(studentData$Fiction.Question)
query1 = "select count([UNIQUE.ID]) as noOFforce from studentData where [Fiction.Question] = 'force' and [Time.Spend.on.Quiz..mins.] <16"
query3 = "select count([UNIQUE.ID]) as noOFforce from studentData where [Fiction.Question] = 'Force' and [Time.Spend.on.Quiz..mins.] <16"
query2 = "select count([UNIQUE.ID]) as noOFforce from studentData where [Fiction.Question] = 'Force' and [Time.Spend.on.Quiz..mins.] >= 16"
query4 = "select count([UNIQUE.ID]) as noOFforce from studentData where [Fiction.Question] = 'force' and [Time.Spend.on.Quiz..mins.] >= 16"


caseSensitive = sqldf(query2)
caseInsensitive = sqldf(query1)
caseRandom = sqldf(query3)
caseCheck = sqldf(query4)

countAbove16 = sqldf("select count([UNIQUE.ID]) as countPpl from studentData where [Time.Spend.on.Quiz..mins.] > 16")
allSleepsSame = sqldf("select count([UNIQUE.ID]) as countPpl from studentData where [SLEEP.MEDIAN] = [SLEEP.AVG] and [SLEEP.AVG]=[SLEEP.MODE]")
empiricalRelation = sqldf("select count([UNIQUE.ID]) as countPpl from studentData where [SLEEP.MODE] = 3*[SLEEP.MEDIAN] - 2*[SLEEP.AVG]")

#lowerStudentData = tolower(studentData)
#raisedStudent = sqldf("select [UNIQUE.ID] as people from studentData where studentData ")

countA = subset(studentData, Expected.Grade=='A')
countThursay = subset(countA, Night.HW.Due == 'Thursday night')
countSunday = subset(countA, Night.HW.Due == 'Sunday night')

countB = subset(studentData, Expected.Grade=='B')
countBThursay = subset(countB, Night.HW.Due == 'Thursday night')
countBSunday = subset(countB, Night.HW.Due == 'Sunday night')
countBTuesday = subset(countB, Night.HW.Due == 'Tuesday night')
countBSaturday= subset(countB, Night.HW.Due == 'Saturday night')

ggplot(studentData, aes(x = Expected.Grade, fill = Night.HW.Due)) +  geom_bar()
ggplot(studentData, aes(x = Favorite.Cookie, fill = Expected.Grade)) +  geom_bar()

studentData$Time.Spend.on.Quiz..mins. = as.numeric(as.character(studentData$Time.Spend.on.Quiz..mins.))
lessTime = subset(studentData, as.numeric(Time.Spend.on.Quiz..mins.) <= 14)
moreTime = subset(studentData, as.numeric(Time.Spend.on.Quiz..mins.) > 14)
ggplot(lessTime, aes(x = Expected.Grade)) +  geom_bar() + ggtitle("Student taking time <= 14 min") 
ggplot(lessTime, aes(x = Favorite.Cookie)) +  geom_bar()
ggplot(lessTime, aes(x = NAMESPACE.COLOR)) +  geom_bar()

ggplot(moreTime, aes(x = NAMESPACE.COLOR)) +  geom_bar()
ggplot(moreTime, aes(x = Expected.Grade)) +  geom_bar() + ggtitle("Student taking time >14 min") 
ggplot(moreTime, aes(x = Favorite.Cookie)) +  geom_bar()

studentData$Gender <- NA
studentData$FIRST <- Names$FirstName

gen1<-gender(tolower(studentData$FIRST))

studentData$FIRST <-tolower(studentData$FIRST)
join_string <- "select studentData.*, gen1.gender from studentData left join gen1 on studentData.FIRST=gen1.name"

genderCompleteDataset <- sqldf(join_string,stringsAsFactors = FALSE)
ggplot(genderCompleteDataset, aes(x=Favorite.Cookie, fill=gender)) + geom_bar()
ggplot(genderCompleteDataset, aes(x=Expected.Grade, fill=gender)) + geom_bar()
ggplot(genderCompleteDataset, aes(x=NAMESPACE.COLOR, fill=gender)) + geom_bar()
ggplot(genderCompleteDataset, aes(x=Night.HW.Due, fill=gender)) + geom_bar()

