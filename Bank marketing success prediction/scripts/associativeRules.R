temp<-trainingDataSetMICE

#Converting values to categorical or binary
temp<-replace(temp, TRUE, lapply(trainingDataSetMICE, factor))

#Extracting rules with suppport and confidence threshold
rules <- apriori(temp, parameter = list(minlen=3, supp=0.005, conf=0.8), appearance = list(rhs=c("y=no", "y=yes"), default="lhs"), control = list(verbose=F))
quality(rules) <- cbind(quality(rules), coverage = coverage(rules))
rules.sorted <- sort(rules, by="lift")
toprules<-rules[1:10000]

#Identifying if there are any redundant rules
#Taken from http://www.rdatamining.com/examples/association-rulessubset.matrix <- is.subset(toprules, toprules)
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
redundant <- colSums(subset.matrix, na.rm=T) >= 1
rules.pruned <- toprules[!redundant]
inspect(rules.pruned)

plot(rules.pruned, method = "paracoord", control=list(reorder=TRUE))
plot(rules.pruned, method = "matrix3D",measure="lift", control=list(reorder=TRUE))
plot(rules.pruned, method="graph", control=list(type="itemsets"))
