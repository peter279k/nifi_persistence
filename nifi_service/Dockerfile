FROM apache/nifi:2.0.0

USER root
RUN apt-get update && apt-get -y install python3 python3-pip && PIP_BREAK_SYSTEM_PACKAGES=1 pip3 install pymongo pandas

USER nifi
