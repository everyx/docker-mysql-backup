#!/bin/sh

set -e

BACKUP_PATH="/backup"
DATETIME=$(date +"%s_%Y-%m-%d")
if [ ! -d $BACKUP_PATH ]; then
    mkdir -p $BACKUP_PATH
fi

dump() {
    NAME="$1.$DATETIME.gz"
    echo "Start dump $NAME"

    mysqldump --routines --triggers --single-transaction --quick --lock-tables=false --dump-date \
        --user "$MYSQL_USER" \
        --password"$MYSQL_PASSWORD" \
        --host "$MYSQL_HOST" \
        --port "$MYSQL_PORT" \
        "$NAME" | gzip >"${BACKUP_PATH:?}/$NAME"

    backup "$NAME"
}

dump_all() {
    NAME="all.$DATETIME.gz"
    echo "Start dump $NAME"

    mysqldump --routines --triggers --single-transaction --quick --lock-tables=false --dump-date \
        --user "$MYSQL_USER" \
        --password"$MYSQL_PASSWORD" \
        --host "$MYSQL_HOST" \
        --port "$MYSQL_PORT" \
        --all-databases | gzip >"${BACKUP_PATH:?}/$NAME"

    backup "$NAME"
}

backup() {
    if [ "$RCLONE_DEST" -eq "" ]; then
        return 1
    fi

    echo "Start copy"
    rclone --config /rclone.conf copy "${BACKUP_PATH:?}/$1" "$RCLONE_DEST"
    rm -rf "${BACKUP_PATH:?}/$1"
}

if [ "$MYSQL_DATABASES" -eq "" ]; then
    dump_all
else
    for db in $MYSQL_DATABASES; do
        dump "$db"
    done
fi

echo "Done"
