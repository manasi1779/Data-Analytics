#K-means clustering


NormalizedData$Size <- gsub("^$", NA, NormalizedData$Size)
NormalizedData <- na.omit(NormalizedData)
NumericNormalizedData <- NormalizedData

NumericNormalizedData$Size <- gsub("COMPACT", 0, NumericNormalizedData$Size)
NumericNormalizedData$Size <- gsub("SPORTS", 1, NumericNormalizedData$Size)
NumericNormalizedData$Size <- gsub("SMALL SUV", 2, NumericNormalizedData$Size)
NumericNormalizedData$Size <- gsub("SMALL TRUCK", 3, NumericNormalizedData$Size)
NumericNormalizedData$Size <- gsub("MEDIUM SUV", 5, NumericNormalizedData$Size)
NumericNormalizedData$Size <- gsub("CROSSOVER", 6, NumericNormalizedData$Size)
NumericNormalizedData$Size <- gsub("SPECIALTY", 7, NumericNormalizedData$Size)
NumericNormalizedData$Size <- gsub("LARGE SUV", 9, NumericNormalizedData$Size)
NumericNormalizedData$Size <- gsub("VAN", 10, NumericNormalizedData$Size)
NumericNormalizedData$Size <- gsub("LARGE TRUCK", 11, NumericNormalizedData$Size)
NumericNormalizedData$Size <- gsub("MEDIUM", 4, NumericNormalizedData$Size)
NumericNormalizedData$Size <- gsub("LARGE", 8, NumericNormalizedData$Size)

NumericNormalizedData$DoorType <- gsub("[A-Z]", "", NumericNormalizedData$DoorType)
NumericNormalizedData$Engine <- gsub("[A-Z]", "", NumericNormalizedData$Engine)

NumericNormalizedData$DoorType <- as.numeric(NumericNormalizedData$DoorType)
NumericNormalizedData$Engine <- as.numeric(NumericNormalizedData$Engine)

uniqueSize <- unique(NormalizedData$Size)
NumericNormalizedData$IsBadBuy <- as.factor(NumericNormalizedData$IsBadBuy)
NumericNormalizedData$IsOnlineSale <- as.factor(NumericNormalizedData$IsOnlineSale)

#NumericNormalizedData <- subset(NumericNormalizedData, select = -c(Color, WheelType, Nationality, TopThreeAmericanName, Transmission))

set.seed(20)
carClusters <- kmeans(subset(NumericNormalizedData, select=-c(VNST, Make)), 5)

plot(subset(NumericNormalizedData, select=-c(VNST, Make)), col = carClusters$cluster)

"
COMPACT -> 0
SPORTS ->1
SMALL SUV -> 2
SMALL TRUCK -> 3
MEDIUM -> 4
MEDIUM SUV -> 5
CROSSOVER -> 6
SPECIALTY -> 7
LARGE -> 8
LARGE SUV -> 9
VAN -> 10
LARGE TRUCK -> 11"
