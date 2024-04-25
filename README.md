## MySQL Backup Docker Image

This Dockerfile sets up a container for automating MySQL backups to Azure Blob Storage. It installs necessary dependencies, including MySQL client and Azure CLI, and configures environment variables for customization.

### Environment Variables

- `MYSQL_HOST`: MySQL database host address.
- `MYSQL_PORT`: MySQL database port.
- `MYSQL_USERNAME`: MySQL database username.
- `MYSQL_PASSWORD`: MySQL database password.
- `AZURE_STORAGE_ACCOUNT_NAME`: Azure Storage account name.
- `AZURE_STORAGE_ACCOUNT_KEY`: Azure Storage account key.
- `AZURE_STORAGE_CONTAINER_NAME`: Azure Storage container name.
- `BACKUP_TIME`: Time to run the backup script in HH:MM format. Default is 02:00.

### Setup Instructions

#### Using Docker Hub Image

1. Pull the Docker image from Docker Hub:

    ```bash
    docker pull gabrielheck/mysql-backup-azblob
    ```

2. Run the Docker container:

    ```bash
    docker run -d \
      -e MYSQL_HOST=<your_mysql_host> \
      -e MYSQL_PORT=<your_mysql_port> \
      -e MYSQL_USERNAME=<your_mysql_username> \
      -e MYSQL_PASSWORD=<your_mysql_password> \
      -e AZURE_STORAGE_ACCOUNT_NAME=<your_azure_storage_account_name> \
      -e AZURE_STORAGE_ACCOUNT_KEY=<your_azure_storage_account_key> \
      -e AZURE_STORAGE_CONTAINER_NAME=<your_azure_storage_container_name> \
      -e BACKUP_TIME=<backup_time> \
      gabrielheck/mysql-backup-azblob
    ```

#### Building from Source

1. Clone this repository.
2. Build the Docker image:

    ```bash
    docker build -t mysql-backup .
    ```

3. Run the Docker container:

    ```bash
    docker run -d \
      -e MYSQL_HOST=<your_mysql_host> \
      -e MYSQL_PORT=<your_mysql_port> \
      -e MYSQL_USERNAME=<your_mysql_username> \
      -e MYSQL_PASSWORD=<your_mysql_password> \
      -e AZURE_STORAGE_ACCOUNT_NAME=<your_azure_storage_account_name> \
      -e AZURE_STORAGE_ACCOUNT_KEY=<your_azure_storage_account_key> \
      -e AZURE_STORAGE_CONTAINER_NAME=<your_azure_storage_container_name> \
      -e BACKUP_TIME=<backup_time> \
      mysql-backup
    ```

### Important Notes

- Ensure that the necessary environment variables are correctly set to connect to your MySQL database and Azure Storage account.
- Customize the `backup.sh` script according to your specific backup requirements.
- Adjust the `BACKUP_TIME` environment variable to schedule backups at your preferred time.

### Disclaimer

This Docker image is provided as-is, without any warranty. Use it at your own risk.

For more information, refer to the [official Docker documentation](https://docs.docker.com/).
