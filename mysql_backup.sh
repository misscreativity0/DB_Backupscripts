#!/bin/bash

# TODO:
# Run as a cronjob
# Connect via SSH with keys
# Backup files
# Delete old files from wp-server


DATENOW=$(date "+%F_%T")
DB_NAME=""
DB_USER=""
DB_PASSWD=""
DB_HOST=""
BACKUPDIR="blog_backups"
BACKUPNAME="db_backup_"$DB_NAME"_"$DATENOW""
LOGFILE="$BACKUPNAME.log"

mkdir -p "$BACKUPDIR"

mysqldump -u $DB_USER -p$DB_PASSWD -h $DB_HOST --databases $DB_NAME --single-transaction \
 | gzip > "$BACKUPDIR/$BACKUPNAME".gz
du -h --total "$BACKUPDIR"/* > "$LOGFILE"
cat "$LOGFILE"
