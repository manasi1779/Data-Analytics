###########################################################################################################################
#															  #
#					Data Mining model for Bank Marketing Dataset					  #
#															  #
#															  #
###########################################################################################################################

Bank Marketing dataset is availble in the form of CSV. We have created a project using R and sqlite for making a data mining model. Following are steps to run the project

1. Run loadLibs.r to install and load libraries
2. Run mysqlconn.r to load data to sqlite db
3. Run correlationMatrix.R to join data from different sources and create correlation matrix
4. Run preliminaryAnalysis.R for preliminary analysis of data
5. Run dataCleaning.R for data imputation and up\down sampling
6. Run associativeRules.R for analysis of data using associative rules
7. Run randomForestModel.R to create RandomForest model and predict values for test data.