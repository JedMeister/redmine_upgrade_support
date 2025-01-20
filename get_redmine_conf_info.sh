#!/bin/bash -e

DUMP_DIR=/root/info-dump
mkdir -p $DUMP_DIR/{conf,apache}

if [[ "$(turnkey-version)" == "turnkey-redmine-11"* ]]; then
    APP=railsapp
else
    APP=redmine
fi

APP_DIR="/var/www/$APP"

ls -lA "$APP_DIR" > "$DUMP_DIR/app-dir"
ls -lA "$APP_DIR/config" > "$DUMP_DIR/redmine-conf-dir"
ls -lA "/srv/repos/svn" > "$DUMP_DIR/repo-dirs"

for CONF in "$CONFIG_DIR/"*yml*; do
    cp -a "$CONF" "$DUMP_DIR/conf/"
done

for DIR in conf sites-enabled; do
    cp "/etc/apache2/$DIR/$APP.conf" "$DUMP_DIR/apache/$DIR-$APP.conf"
done

mysql --execute "SHOW DATABASES;" > "$DUMP_DIR/mysql-databases"
mysql --execute "SELECT User FROM mysql.user;" > "$DUMP_DIR/mysql-users"

tar -czvf "/root/redmine-info-$EPOCHSECONDS".tar.gz "$DUMP_DIR"
