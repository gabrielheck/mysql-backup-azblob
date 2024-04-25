# Base image
FROM ubuntu:20.04

# set default environment variables
ENV MYSQL_HOST=None
ENV MYSQL_PORT=3306
ENV MYSQL_USERNAME=None
ENV MYSQL_PASSWORD=None
ENV AZURE_STORAGE_ACCOUNT_NAME=None
ENV AZURE_STORAGE_ACCOUNT_KEY=None
ENV AZURE_STORAGE_CONTAINER_NAME=None
ENV BACKUP_TIME=02:00

# install mysqldump
RUN apt-get update && \
    apt-get install -y mysql-client && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install packages required to run the azure cli installation
RUN	apt-get update && apt-get -y install curl && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install azure cli
RUN	curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# add backup script
ADD backup.sh /
RUN chmod +x /backup.sh

# Run backup script at specified time
CMD sleep $(( ($(date -d "$BACKUP_TIME" +%s) - $(date +%s) + 86400) % 86400 )) && sh /backup.sh
