echo $(hostname) > /opt/spark/conf/slaves
pyspark #--jars /usr/bin/spark-csv.jar,/usr/bin/uni-parsers.jar,/usr/bin/com-csv.jar