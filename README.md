# SparkPy

Spark environment with Python interface via Jupyter Notebook.

Includes spark-csv package.

## Setup
### Build
**docker build -t** sparkpy **--no-cache=true** github.com/lucianmoldovanu/SparkPy

### Run (with mounted folder)
**docker run -v** '/c/Users/i311766/Documents/LucProjects/NasaPDMS/':/nasa/ **--rm -p** 8888:8888 **-p** 4040:4040 **-i** lucianmol/sparkpy

### SSH into docker container
**docker run -i -t --entrypoint** /bin/bash \<imageID\>

## Test
### Test spark-csv
from pyspark.sql import SQLContext
sqlContext = SQLContext(sc)

df = sqlContext.read.format('com.databricks.spark.csv').options(header='true', inferschema='true') \
  .load('file:///data/Fault_Fan/Engine01/Flight001.csv')

