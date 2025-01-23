FROM apache/nifi:2.1.0

USER root
RUN apt-get update && apt-get -y install python3 python3-pip && pip3 install pymongo pandas --break-system-packages

USER nifi
