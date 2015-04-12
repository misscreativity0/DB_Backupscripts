#!/bin/bash

# crontab example:
# 1 4 * * * /usr/local/bin/backuppgsql daily
# 1 5 * * 0 /usr/local/bin/backuppgsql weekly

if [ "$1" != "daily" ] && [ "$1" != "weekly" ]; then
        echo "Syntax: $(basename $0) daily|weekly"
        exit 1
fi

DATENOW=$(date "+%F_%T")
DB_USER="root"
USERNAME="CHANGEME"
BACKUPROOT="/home/$USERNAME/pgsql_backups/$1/"
export PGPASSWORD="CHANGEME"


function backup_table()
{
        DB_NAME="$1"
        BACKUPDIR="$BACKUPROOT/$DB_NAME"
        BACKUPNAME="db_backup_"$DB_NAME"_"$DATENOW""
        LOGFILE="$BACKUPDIR/$BACKUPNAME.log"

        echo "Creating Backup $BACKUPDIR/$BACKUPNAME..."
        mkdir -p "$BACKUPDIR"

        pg_dump -U $DB_USER $DB_NAME | xz > "$BACKUPDIR/$BACKUPNAME".xz

        echo "Removing all backups except for the last 7..."
        find "$BACKUPDIR" -type f | sort | head -n -7 | xargs rm

        echo "Contents:"
        du -h --total "$BACKUPDIR"/*
}



# create backups
backup_table "ttrss"
backup_table "owncloud"

# restore backups: http://www.postgresql.org/docs/8.1/static/backup.html#BACKUP-DUMP-RESTORE
