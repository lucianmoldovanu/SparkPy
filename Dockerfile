FROM ubuntu:14.04

ADD launcher.sh /usr/bin/launcher.sh
ADD spark-csv_2.11-1.4.0.jar /usr/bin/spark-csv.jar
ADD univocity-parsers-2.1.2.jar /usr/bin/uni-parsers.jar
ADD commons-csv-1.4.jar /usr/bin/com-csv.jar

RUN apt-get -qq update			&& \
	apt-get -qq -y install wget	\
			curl

RUN echo 'Downloading Anaconda ...' && \
	wget -qO /opt/Anaconda.sh https://repo.continuum.io/archive/Anaconda2-2.5.0-Linux-x86_64.sh	

RUN echo 'Downloading Spark ...' && \
	wget -qO /opt/spark.tgz http://d3kbcqa49mib13.cloudfront.net/spark-1.6.1-bin-hadoop2.6.tgz

RUN chmod +x /usr/bin/launcher.sh                    			&& \
    export DEBIAN_FRONTEND=noninteractive				&& \
	apt-get -qq update                                              && \
    apt-get -qq -y install git	\
                           vim  \
                           jq   \
                           mc   \
                           default-jdk                                  && \
    echo 'Installing Anaconda ...'                             		&& \
    bash /opt/Anaconda.sh -b -p /opt/anaconda         			&& \
    rm /opt/Anaconda.sh							&& \
    conda install -c r ipython-notebook r-irkernel			&& \
    echo 'Installing seaborn (Python module) ...'                       && \
    PATH=/opt/anaconda/bin:$PATH pip install seaborn                    && \
    echo 'Extracting Spark ...'                                         && \
    tar -xf /opt/spark.tgz -C /opt                                      && \
    rm /opt/spark.tgz                                                   && \
    mv /opt/spark-* /opt/spark                                          && \
    cd /opt/spark/conf                                                  && \
    sed 's/INFO/ERROR/' log4j.properties.template > log4j.properties    && \
    echo $(hostname) > slaves                                           && \
    cd /opt                                                             && \
    echo 'Building container, this may take a while ...'

ENV SPARK_HOME=/opt/spark                             		\	
    PYSPARK_PYTHON=/opt/anaconda/bin/python           		\
    IPYTHON_OPTS='notebook --no-browser --ip=0.0.0.0' 		\
    PATH=/opt/anaconda/bin:/opt/spark/bin:$PATH

CMD ["bash", "-c", "/usr/bin/launcher.sh"]

## TODO: add
# conda update ipython-notebook

# docker build -t sparkworkshop github.com/dserban/SparkWorkshop
# docker run -p 8888:8888 -p 4040:4040 -it dserban/sparkworkshop sh -c /opt/launcher.sh
