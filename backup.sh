#!/bin/bash

# Function to display error message and exit
function display_error {
    echo "Error: $1"
    exit 1
}

# Validate number of parameters or check for environment variables
if [ "$#" -eq 0 ]; then
    if [ -z "$MYSQL_HOST" ] || [ -z "$MYSQL_PORT" ] || [ -z "$MYSQL_USERNAME" ] || [ -z "$MYSQL_PASSWORD" ] || [ -z "$AZURE_STORAGE_ACCOUNT_NAME" ] || [ -z "$AZURE_STORAGE_ACCOUNT_KEY" ] || [ -z "$AZURE_STORAGE_CONTAINER_NAME" ]; then
        display_error "Required environment variables are not set. Set the following environment variables: MYSQL_HOST, MYSQL_PORT, MYSQL_USERNAME, MYSQL_PASSWORD, AZURE_STORAGE_ACCOUNT_NAME, AZURE_STORAGE_ACCOUNT_KEY, AZURE_STORAGE_CONTAINER_NAME"
    fi
elif [ "$#" -ne 7 ]; then
    display_error "Usage: $0 <MYSQL_HOST> <MYSQL_PORT> <MYSQL_USERNAME> <MYSQL_PASSWORD> <AZURE_STORAGE_ACCOUNT_NAME> <AZURE_STORAGE_ACCOUNT_KEY> <AZURE_STORAGE_CONTAINER_NAME>"
fi

# Assign MySQL parameters from either parameters or environment variables
MYSQL_HOST="${1:-$MYSQL_HOST}"
MYSQL_PORT="${2:-$MYSQL_PORT}"
MYSQL_USERNAME="${3:-$MYSQL_USERNAME}"
MYSQL_PASSWORD="${4:-$MYSQL_PASSWORD}"
AZURE_STORAGE_ACCOUNT_NAME="${5:-$AZURE_STORAGE_ACCOUNT_NAME}"
AZURE_STORAGE_ACCOUNT_KEY="${6:-$AZURE_STORAGE_ACCOUNT_KEY}"
AZURE_STORAGE_CONTAINER_NAME="${7:-$AZURE_STORAGE_CONTAINER_NAME}"

# Output directory and file
OUTPUT_DIR="/tmp"
OUTPUT_FILE_NAME="$(date +"%Y-%m-%dT%H%M%SZ")".gz
OUTPUT_FILE_PATH="$OUTPUT_DIR/$OUTPUT_FILE_NAME"

echo "Executing mysqldump."
# Execute mysqldump and handle errors
mysqldump \
    -h "$MYSQL_HOST" \
    -P "$MYSQL_PORT" \
    -u "$MYSQL_USERNAME" \
    -p"$MYSQL_PASSWORD" \
    --all-databases --triggers --routines --events --single-transaction \
    | gzip > "$OUTPUT_FILE_PATH" || display_error "Failed to execute mysqldump. Check MySQL connection parameters."

echo "Uploading dump to Azure blob storage"

# Execute az storage blob upload and handle errors
az storage blob upload \
  --account-name "$AZURE_STORAGE_ACCOUNT_NAME" \
  --account-key "$AZURE_STORAGE_ACCOUNT_KEY" \
  --container-name "$AZURE_STORAGE_CONTAINER_NAME" \
  --file "$OUTPUT_FILE_PATH" \
  --name "$OUTPUT_FILE_NAME" || display_error "Failed to upload dump to Azure blob storage."

echo "Dump uploaded successfully."
