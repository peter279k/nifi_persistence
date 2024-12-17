#!/bin/bash

read -p "Do you want to reset NiFi configurations? " ans

if [[ $ans == "Y" || $ans == "y" ]]; then
    docker compose down
    rm -rf nifi_conf/ nifi_registry_conf/ nifi_registry_database/ nifi_registry_flow_storage/
else
    exit 0;
fi
