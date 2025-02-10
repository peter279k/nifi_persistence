#!/bin/bash

# https://medium.com/geekculture/host-a-fully-persisted-apache-nifi-service-with-docker-ffaa6a5f54a3

echo "Starting tricky NiFi persistence..."

docker compose up -d --build

echo "Sleep 200 seconds to wait for all containers are started..."
sleep 200

for number in 1 2 3
do
    echo "Copy /opt/nifi/nifi-current/conf to host ./nifi${number}_conf/ directory"
    docker compose cp nifi-$number:/opt/nifi/nifi-current/conf "./nifi${number}_conf"
done;


echo "Copy /opt/nifi-registry/nifi-registry-current/conf to host $PWD directory"
docker compose cp registry:/opt/nifi-registry/nifi-registry-current/conf ./nifi_registry_conf

docker compose stop

echo "Setting related nifi and nifi_registry permissions is done."
sudo chown -R 1000:1000 nifi_registry_database nifi_registry_flow_storage nifi_registry_conf

for number in 1 2 3
do
    sudo chown -R 1000:1000 "./nifi${number}_conf"
done;


rm -f truststore.p12 keystore.p12
echo "Generating the truststore.p12 and keystore.p12 with the keytool"
check_keytool=$(which keytool)
if [[ $check_keytool == '' ]]; then
    echo "keytool command not found."
    exit 1;
fi;


keystore_pass=$(cat ./nifi1_conf/nifi.properties | grep 'nifi.security.keystorePasswd' | awk '{split($1,a,"="); print a[2]}')
truststore_pass=$(cat ./nifi1_conf/nifi.properties | grep 'nifi.security.truststorePasswd' | awk '{split($1,a,"="); print a[2]}')

echo "Generating the PKCS12 keypair"

if [[ ! -f "SAN.txt" ]]; then
    echo "SAN.txt file is not found."
    exit 1;
fi;

san_setting=$(cat "SAN.txt")

keytool -storepass $keystore_pass -genkeypair -alias nifi-cert -keyalg RSA -keysize 2048 -validity 365 -keystore keystore.p12 -storetype PKCS12 -dname "CN=nifi, OU=III, O=III, L=Taipei, S=Sonshan, C=TW" -ext "SAN=$san_setting"

echo "Export the cert"
keytool -storepass $keystore_pass -exportcert -alias nifi-cert -file nifi-cert.crt -keystore keystore.p12 -storetype PKCS12

echo "Create the truststore"
echo "yes" | keytool -storepass $truststore_pass -importcert -alias nifi-cert -file nifi-cert.crt -keystore truststore.p12 -storetype PKCS12

for number in 1 2 3
do
    echo "Copying truststore.p12, keystore.p12 and nifi.properties to the ./nifi${number}_conf directory"
    cp truststore.p12 ./nifi${number}_conf/truststore.p12
    cp keystore.p12 ./nifi${number}_conf/keystore.p12
    if [[ $number > 1 ]]; then
        cp ./nifi1_conf/nifi.properties ./nifi${number}_conf/nifi.properties
    fi;
done;

echo "Remove related cert files"
rm -f nifi-cert.crt truststore.p12 keystore.p12

echo "Uncomment the next line after copying the /conf directory from the container to your local directory to persist NiFi flows"
sed -i s/\#\-/\-/g docker-compose.yml
docker compose up -d

echo "Starting tricky NiFi persistence has been done."
