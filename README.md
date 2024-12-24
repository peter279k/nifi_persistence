# NiFi persistence

## Introduction

- This project is for the `docker-compose.yml` NiFi with file and git persistence storages
- It's the automated NiFi 2.0 building script

## Usage

- If we want to use the file persistence storage, we can use following steps:

1. Cloning this repository via the `git clone https://github.com/peter279k/nifi_persistence`.
2. Copy the `providers.xml.file` to the `providers.xml` file.
3. Copy the `docker-compose-file.yml` to the `docker-compose.yml` file.
4. Creating the `SAN.txt` file and it can refer the `SAN.txt.example` file.
5. Run the `run_nifi_file.sh` to create the NiFi and NiFi registry services firstly.

- If we want to use the Git persistence storage, we can use following steps:

1. Cloning this repository via the `git clone https://github.com/peter279k/nifi_persistence`.
2. Copy the `providers.xml.git` to the `providers.xml` file then edit correct Git flow settings.
3. Copy the `docker-compose-git.yml` to the `docker-compose.yml` file.
4. Creating the `SAN.txt` file and it can refer the `SAN.txt.example` file.
5. Run the `run_nifi_git.sh` to create the NiFi and NiFi registry services firstly.

- If we want to use the file persistence storage with the MongoDB, we can use following steps:

1. Cloning this repository via the `git clone https://github.com/peter279k/nifi_persistence`.
2. Copy the `providers.xml.file` file to the `providers.xml` file.
3. Creating the `SAN.txt` file and it can refer the `SAN.txt.example` file.
4. Run the `run_nifi_file.sh` to create the NiFi and NiFi registry services firstly.

## References

- https://www.youtube.com/watch?v=j0zrNz3ONZI
- https://medium.com/devops-central/integrating-git-with-nifi-registries-a-step-by-step-guide-f9f74c2ba046
- https://medium.com/geekculture/host-a-fully-persisted-apache-nifi-service-with-docker-ffaa6a5f54a3

## Troubleshooting

- `Apache NIFI 2+ HTTP ERROR 400 Invalid SNI` message will present when migrating to the `2.0`.

1. https://stackoverflow.com/questions/78985347/apache-nifi-2-http-error-400-invalid-sni
