#!/bin/bash

echo -e "\e[31mThis script is for Git version control has not been ready yet!\e[0m"
exit 1;

# https://medium.com/geekculture/host-a-fully-persisted-apache-nifi-service-with-docker-ffaa6a5f54a3

echo "Starting tricky NiFi persistence..."

docker compose up -d

echo "Sleep 100 seconds to wait for all containers are started..."
sleep 100

echo "Copy /opt/nifi/nifi-current/conf to host ./nifi/ directory"
docker compose cp nifi:/opt/nifi/nifi-current/conf ./nifi_conf

echo "Copy /opt/nifi-registry/nifi-registry-current/conf/providers.xml to host $PWD directory"
docker compose cp registry:/opt/nifi-registry/nifi-registry-current/conf ./nifi_registry_conf

docker compose stop

echo "Setting related nifi and nifi_registry permissions is done."
sudo chown -R 1000:1000 nifi_conf nifi_registry_database nifi_registry_flow_storage nifi_registry_conf
cp providers.xml ./nifi_registry_conf/providers.xml

echo "Setting the nifi_registry_flow_storage for the Git version control"
cd nifi_registry_flow_storage
git init
git remote add origin https://gitlab.com/iii-api-platform/versioned_nifi_flow
cd ..

echo "Uncomment the next line after copying the /conf directory from the container to your local directory to persist NiFi flows"
sed -i s/\#\-/\-/g docker-compose.yml
docker compose up -d

echo "Starting tricky NiFi persistence has been done."
