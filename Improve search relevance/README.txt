*************************************************************************************************************************
*				Enhancing Product Suggestion System for Online Businesses				*
*															*
* @author: Manasi Sunil Bharde: msb4977@rit.edu										*	* @author: Surabhi Rajeev Marathe: srm6226@rit.edu									*
*************************************************************************************************************************
This application creates model for calculating relevance between seaarch term and search result.
We have used classification based on clustering approach for the problem. Following are steps to run model. All the csv files should be kept along with source files.


1. Extract zip file to get scripts and data files.
2. Run createTraining.py: adds data from csvs to python sqllite3 database, Finds frequent occuring attributes in data and	maps values of attributes to product ids. Creates derived.csv to be used by R script.
4. Run readData.r: Reads data into R and creates tables in R
5. Run textClustering.r : creates clusters using product data. Uses stringdist methods which are found to give best performance
6. Run basicModel.r: creates random forest model and predicts outcome for test data using model.



