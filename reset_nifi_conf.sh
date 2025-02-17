#!/bin/bash

read -p "Do you want to reset NiFi configurations?[Y/n] " ans

if [[ $ans == "Y" || $ans == "y" ]]; then
    docker compose down
    rm -rf nifi_conf/ nifi_registry_conf/ nifi_registry_database/ nifi_registry_flow_storage/
    rm -rf nifi1_conf/ nifi2_conf/ nifi3_conf/
else
    exit 0;
fi
