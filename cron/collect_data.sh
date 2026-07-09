#!/bin/bash

TARGET_DIR="/home/cron"
SOURCE_URL="https://example.com/api/resource"
LOG_FILE="${TARGET_DIR}/collect.log"

mkdir -p "$TARGET_DIR"

DATE_PART=$(date +"%m%d%Y")
TIME_PART=$(date +"%H.%M")

FILE_NAME="cron_${DATE_PART}_${TIME_PART}.csv"
FILE_PATH="${TARGET_DIR}/${FILE_NAME}"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting data collection -> ${FILE_NAME}" >> "$LOG_FILE"

curl -s -o "$FILE_PATH" "$SOURCE_URL"

if [ $? -eq 0 ] && [ -s "$FILE_PATH" ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: Saved to ${FILE_PATH}" >> "$LOG_FILE"
else
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Failed to collect data" >> "$LOG_FILE"
  exit 1
fi
