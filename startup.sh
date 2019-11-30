#!/bin/sh

if [ -d /app/mysql ]; then
    echo "[i] MySQL directory already present, skipping creation"
else
    echo "[i] MySQL data directory not found, creating initial DBs"

    # 装数据库
    mysql_install_db --user=root >/dev/null

    # 初始密码
    if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
        #MYSQL_ROOT_PASSWORD=111111
        MYSQL_ROOT_PASSWORD=$(date "+%Y-%m-%d %H:%M:%S" | md5sum | cut -d ' ' -f1 | cut -b 1-6)
        #MYSQL_ROOT_PASSWORD=$(date "+%Y-%m-%d %H:%M:%S" | base64 | cut -b 22-27)
        echo "[i] MySQL root Password: $MYSQL_ROOT_PASSWORD"
    fi

    MYSQL_DATABASE=${MYSQL_DATABASE:-""}
    MYSQL_USER=${MYSQL_USER:-""}
    MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

    # mysql服务安装目录
    if [ ! -d "/run/mysqld" ]; then
        mkdir -p /run/mysqld
    fi

    # mysql数据初始文件
    tfile=$(mktemp)
    if [ ! -f "$tfile" ]; then
        return 1
    fi
    # 其：
    # 设置远程登录
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

        if [ "$MYSQL_USER" != "" ]; then
            echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
            echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >>$tfile
        fi
    fi
    # mysqld服务启动
    /usr/bin/mysqld --user=root --bootstrap --verbose=0 <$tfile
    # 删除初始文件
    rm -f $tfile
fi

exec /usr/bin/mysqld --user=root --console
