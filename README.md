# NiFi persistence

## Introduction

- This project is for the `docker-compose.yml` NiFi with file and git persistence storages

## Usage

- If we want to use the file persistence storage, we can use following steps:

1. Cloning this repository via the `git clone https://github.com/peter279k/nifi_persistence`
2. Copy the `providers.xml.file` to the `providers.xml` file
3. Copy the `docker-compose-file.yml` to the `docker-compose.yml` file
4. Run the `run_nifi_file.sh` to create the NiFi and NiFi registry services

- It we want to use the Git persistence storage, we can use following steps:

1. Cloning this repository via the `git clone https://github.com/peter279k/nifi_persistence`
2. Copy the `providers.xml.git` to the `providers.xml` file then edit correct Git flow settings
3. Copy the `docker-compose-git.yml` to the `docker-compose.yml` file
4. Run the `run_nifi_git.sh` to create the NiFi and NiFi registry services

## References

- https://www.youtube.com/watch?v=j0zrNz3ONZI
- https://medium.com/devops-central/integrating-git-with-nifi-registries-a-step-by-step-guide-f9f74c2ba046
- https://medium.com/geekculture/host-a-fully-persisted-apache-nifi-service-with-docker-ffaa6a5f54a3
