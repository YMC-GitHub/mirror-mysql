#!/bin/sh

# set var and its default value
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-""}
MYSQL_DATABASE=${MYSQL_DATABASE:-""}
MYSQL_USER=${MYSQL_USER:-""}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

if [ -d /app/mysql ]; then
    echo "[i] MySQL directory already present, skipping creation"
else
    echo "[i] MySQL data directory not found, creating initial DBs"
    #fix:chown: /app/mysql: No such file or directory
    mkdir -p /app/mysql
    chown -R root:root /app/mysql

    # 装数据库
    echo 'Initializing database'
    mysql_install_db --user=root >/dev/null
    echo 'Database initialized'

    # 初始密码
    if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
        MYSQL_ROOT_PASSWORD=$(date "+%Y-%m-%d %H:%M:%S" | md5sum | cut -d ' ' -f1 | cut -b 1-6)
    fi
    echo "[i] MySQL root Password: $MYSQL_ROOT_PASSWORD"

    # mysql服务安装目录
    if [ ! -d "/run/mysqld" ]; then
        mkdir -p /run/mysqld
        chown -R root:root /run/mysqld
    fi

    # mysql数据初始文件
    tfile=$(mktemp)
    if [ ! -f "$tfile" ]; then
        return 1
    fi

    echo "[i] Create temp file: $tfile"

    echo "[i] setting connect from remote with user root and pass $MYSQL_ROOT_PASSWORD"
    echo "[i] setting connect from local with user root and none pass"
    cat <<EOF >$tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD" WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("") WHERE user='root' AND host='localhost';
EOF
    # 创建数据库
    if [ "$MYSQL_DATABASE" != "" ]; then
        echo "[i] Creating database: $MYSQL_DATABASE"
        echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >>$tfile

        if [ "$MYSQL_USER" != "" ] && [ "$MYSQL_PASSWORD" != "" ]; then
            echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD for database $MYSQL_DATABASE"
            echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >>$tfile
        fi
    else
        # don`t need to create new database,Set new User to control all database.
        if [ "$MYSQL_USER" != "" ] && [ "$MYSQL_PASSWORD" != "" ]; then
            echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD for all database"
            echo "GRANT ALL ON *.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >>$tfile
        fi
    fi
    echo 'FLUSH PRIVILEGES;' >>$tfile

    echo "[i] run tempfile: $tfile"
    # mysqld服务启动
    /usr/bin/mysqld --user=root --bootstrap --verbose=0 <$tfile
    # 删除初始文件
    rm -f $tfile
fi

echo "[i] sleeping 5 sec"
sleep 5

echo '[i] start running mysqld'
exec /usr/bin/mysqld --user=root --console
