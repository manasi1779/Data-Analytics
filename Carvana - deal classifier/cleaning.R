setwd("D:/Study/BDA/Project/CARVANA")
library(SparkR)
if (!require('devtools')) install.packages('devtools')
devtools::install_github('apache/spark@v2.0.0', subdir='R/pkg')
install.packages("installr"); library(installr) #load / install+load installr
updateR() # updating R.
install.packages('sparklyr')
library(sparklyr)

#Sys.setenv(HADOOP_HOME = "C:/Hadoop")
#Sys.setenv(SPARK_HOME = "C:/spark-2.0.1-bin-hadoop2.7")
#Sys.setenv(JAVA_HOME = "C:/Program Files/Java/jdk1.8.0_60")
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
sparkR.session(appName = "SparkR-DataFrame-example", master = "local", sparkConfig = list(spark.driver.memory = "2g", spark.sql.warehouse.dir="C:/tmp"))

#Sys.setenv('SPARKR_SUBMIT_ARGS'='"--packages" "com.databricks:spark-csv_2.11:1.2.0" "sparkr-shell"')
temp <- as.DataFrame(trainingData)
df <- read.df("training.csv", "csv", header = "true", inferSchema = "true", na.strings = "NA")
