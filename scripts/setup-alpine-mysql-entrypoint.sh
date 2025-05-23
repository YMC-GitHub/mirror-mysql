#!/bin/sh
set -euo pipefail

# 配置变量
: ${MYSQL_DATA_DIR:=/var/lib/mysql}
: ${MYSQL_RUN_DIR:=/run/mysqld}
: ${MYSQL_ROOT_PASSWORD:=$(openssl rand -base64 32)}
: ${MYSQL_DATABASE:=}
: ${MYSQL_USER:=}
: ${MYSQL_PASSWORD:=}
: ${MYSQL_WAIT_TIME:=10}

: ${MYSQL_GROUP:=mysql}
: ${MYSQL_USER_NAME:=mysql}

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# 初始化用户和组
init_user(){
    # 检查 mysql 用户和组是否存在
    if ! id -u mysql >/dev/null 2>&1; then
        log "Creating mysql user and group"
        addgroup -S "$MYSQL_GROUP" && adduser -S "$MYSQL_USER_NAME" -G "$MYSQL_GROUP"
    fi
}

# 初始化目录
init_dirs() {
    log "Creating directories: $MYSQL_DATA_DIR and $MYSQL_RUN_DIR"
    mkdir -p "$MYSQL_DATA_DIR" "$MYSQL_RUN_DIR"
    log "Setting ownership for directories: $MYSQL_DATA_DIR and $MYSQL_RUN_DIR"
    chown -R "$MYSQL_USER_NAME":"$MYSQL_GROUP" "$MYSQL_DATA_DIR" "$MYSQL_RUN_DIR"
}

# 初始化数据库
init_db() {
    log "Initializing database in $MYSQL_DATA_DIR"
    mysql_install_db --user="$MYSQL_USER_NAME" --datadir="$MYSQL_DATA_DIR" >/dev/null
    log "Database initialized"

    log "[good] create a temp file to save sql commands, and clean up after using"
    local tfile
    tfile=$(mktemp) || { log "Failed to create temp file"; return 1; }
    trap "rm -f $tfile" EXIT

    log "Configuring MySQL privileges"
    cat <<EOF >$tfile
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
EOF

    if [ -n "$MYSQL_DATABASE" ]; then
        log "Creating database: $MYSQL_DATABASE"
        echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" >>$tfile

        if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ]; then
            log "Creating user: $MYSQL_USER"
            echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >>$tfile
            echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';" >>$tfile
        fi
    fi

    echo "FLUSH PRIVILEGES;" >>$tfile

    /usr/bin/mysqld --user=mysql --bootstrap --datadir="$MYSQL_DATA_DIR" <$tfile
}

# 执行初始化 SQL 文件
init_sql_files() {
    if [ -d /docker-entrypoint-initdb.d ]; then
        log "Executing SQL files in /docker-entrypoint-initdb.d"
        # 按文件名排序后执行
        for f in $(ls /docker-entrypoint-initdb.d/*.sql | sort); do
            if [ -f "$f" ]; then
                log "Executing SQL file: $f"
                mysql -u root -p"$MYSQL_ROOT_PASSWORD" < "$f"
            fi
        done
    fi
}

# 主函数
main() {
    init_user
    if [ ! -d "$MYSQL_DATA_DIR/mysql" ]; then
        init_dirs
        init_db
        log "MySQL root password: $MYSQL_ROOT_PASSWORD"
    fi

    # 如果环境变量 INIT_SQL_FILES 为 true，则执行初始化 SQL 文件
    if [ "${INIT_SQL_FILES:-true}" = "true" ]; then
        init_sql_files
    fi
    
    log "Waiting $MYSQL_WAIT_TIME seconds for system to stabilize"
    sleep "$MYSQL_WAIT_TIME"

    log "Starting MySQL server"
    log "[good] run mysql server with mysql user for security (not use root user)"
    exec /usr/bin/mysqld --user="$MYSQL_USER_NAME" --datadir="$MYSQL_DATA_DIR"
}

# 执行主函数
main