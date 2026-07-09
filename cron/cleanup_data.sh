#!/bin/bash

TARGET_DIR="/home/cron"
LOG_FILE="${TARGET_DIR}/cleanup.log"
DAYS_OLD=30

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting cleanup (files older than ${DAYS_OLD} days)" >> "$LOG_FILE"

find "$TARGET_DIR" -maxdepth 1 -name "cron_*.csv" -type f -mtime +${DAYS_OLD} -print -delete >> "$LOG_FILE" 2>&1

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cleanup finished" >> "$LOG_FILE"
