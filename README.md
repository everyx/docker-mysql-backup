# docker-mysql-backup
backup mysql database to any dest support by rclone

## Useage

```shell
docker run --rm \
    -e MYSQL_USER="mysql-user" \
    -e MYSQL_PASSWORD="mysql-password" \
    -e MYSQL_HOST="mysql-host" \
    -e MYSQL_PORT="3306" \
    -e MYSQL_DATABASES="db1 db2 db3" \
    -e RCLONE_DEST="s3:bucket/path-to-backup/" \
    -v $PWD/your-rclone.conf:/rclone.conf \
    everyx/mysql-backup
```
