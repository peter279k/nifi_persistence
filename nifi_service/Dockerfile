FROM apache/nifi:2.0.0

USER root
RUN apt-get update && apt-get -y install python3 python3-pip && pip3 install pandas

USER nifi
