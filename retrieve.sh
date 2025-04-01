#!/bin/bash

############################
# name: BUC Retriever      #
# version: 0.1             #
# version date: 15/12/2024 #
# author: Adriano Bertanha #
############################

# variables
REMOTE_DIR="crypt-drive:"
LOCAL_DIR="$HOME/backup"
DIR_NAME="$1"
CPIO=$(which cpio)
RCLONE=$(which rclone)
#LOG_FILE="$LOCAL_DIR"/retrieve.log
#exec > >(ts '[%Y-%m-%d %H-%M-%S]' | tee -a "$LOG_FILE") 2>&1

# dowload and decrypt the diserable backup
echo "Downloading and decrypting the backup from $REMOTE_DIR/$DIR_NAME to $LOCAL_DIR..."
$RCLONE copy "$REMOTE_DIR"/"$DIR_NAME" "$LOCAL_DIR" -P || {
	echo "Failed to download or decrypt the backup file."
	exit 1
}

# identify the downloaded and decrypted file name
BACKUP_FILE=$(find "$LOCAL_DIR" -type f -name "*.cpio" -print -quit)

if [[ -z "$BACKUP_FILE" ]];then
	echo "Error: No backup file found in $LOCAL_DIR"
	exit 1
fi
echo "Backup file found: $BACKUP_FILE"

# list the context of the backup file
echo "Backup list of files from $BACKUP_FILE:"
$CPIO -ict < $BACKUP_FILE
read -p "Are you sure you want to decompress this backup(y/n): " CONFIRM

if [ "$CONFIRM" == "n" ] || [ "$CONFIRM" == "N" ];then
	echo "Operation cancelled by user. Deleting the $BACKUP_FILE..."
	rm -f "$BACKUP_FILE"
	echo "Backup file deleted, bye!"
	exit 0
fi

# extract the backup
echo "Extracting the backup..."
cd "$LOCAL_DIR" || exit 2
$CPIO -icdv < "$BACKUP_FILE" || {
	echo "Failed to extract the backup."
	exit 1
}

# clean up
echo "Cleaning up temp files..."
rm -f "$BACKUP_FILE"
echo "Backup restored successfully"
