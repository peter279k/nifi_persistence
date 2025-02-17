#!/bin/bash

# https://medium.com/geekculture/host-a-fully-persisted-apache-nifi-service-with-docker-ffaa6a5f54a3

echo "Starting tricky NiFi persistence..."

sudo docker compose up -d --build

echo "Sleep 100 seconds to wait for all containers are started..."
sleep 100

echo "Copy /opt/nifi/nifi-current/conf to host ./nifi_conf/ directory"
sudo docker compose cp nifi:/opt/nifi/nifi-current/conf ./nifi_conf


echo "Copy /opt/nifi-registry/nifi-registry-current/conf to host $PWD directory"
sudo docker compose cp registry:/opt/nifi-registry/nifi-registry-current/conf ./nifi_registry_conf

sudo docker compose stop

echo "Setting related nifi and nifi_registry permissions is done."
sudo chown -R 1000:1000 nifi_conf nifi_registry_database nifi_registry_flow_storage nifi_registry_conf

rm -f truststore.p12 keystore.p12
echo "Generating the truststore.p12 and keystore.p12 with the keytool"
check_keytook=$(which keytool)
if [[ $check_keytook == '' ]]; then
    echo "keytool command not found."
    exit 1;
fi;


keystore_pass=$(cat ./nifi_conf/nifi.properties | grep 'nifi.security.keystorePasswd' | awk '{split($1,a,"="); print a[2]}')
truststore_pass=$(cat ./nifi_conf/nifi.properties | grep 'nifi.security.truststorePasswd' | awk '{split($1,a,"="); print a[2]}')

echo "Generating the PKCS12 keypair"

if [[ ! -f "SAN.txt" ]]; then
    echo "SAN.txt file is not found."
    exit 1;
fi;

san_setting=$(cat "SAN.txt")

keytool  -storepass $keystore_pass -genkeypair -alias nifi-cert -keyalg RSA -keysize 2048 -validity 365 -keystore keystore.p12 -storetype PKCS12 -dname "CN=nifi, OU=III, O=III, L=Taipei, S=Sonshan, C=TW" -ext "SAN=$san_setting"

echo "Export the cert"
keytool -storepass $keystore_pass -exportcert -alias nifi-cert -file nifi-cert.crt -keystore keystore.p12 -storetype PKCS12

echo "Create the truststore"
echo "yes" | keytool -storepass $truststore_pass -importcert -alias nifi-cert -file nifi-cert.crt -keystore truststore.p12 -storetype PKCS12

echo "Moving truststore.p12 and keystore.p12 to the ./nifi_conf directory"
mv truststore.p12 ./nifi_conf/truststore.p12
mv keystore.p12 ./nifi_conf/keystore.p12

echo "Remove the nifi-cert.crt file"
rm -f nifi-cert.crt

echo "Uncomment the next line after copying the /conf directory from the container to your local directory to persist NiFi flows"
sed -i s/\#\-/\-/g docker-compose.yml
sudo docker compose up -d

echo "Starting tricky NiFi persistence has been done."
