ARG ALPINE_VERSION=3.18
FROM alpine:${ALPINE_VERSION}

# 元数据
LABEL org.opencontainers.image.authors="ymc-github <yemiancheng@gmail.com>; yemiancheng <yemiancheng1993@163.com>"

# 环境变量
ENV TIMEZONE=Asia/Shanghai \
  MYSQL_DATA_DIR=/var/lib/mysql

# 配置镜像源
ARG NETWORK=cn APK_REPO_CN=mirrors.aliyun.com APK_REPO_GLOBAL=dl-cdn.alpinelinux.org
COPY scripts/setup-alpine-apk-repos.sh /usr/local/bin/setup-alpine-apk-repos.sh
RUN chmod +x /usr/local/bin/setup-alpine-apk-repos.sh && \
    setup-alpine-apk-repos.sh

# 安装依赖
COPY scripts/setup-alpine-mysql-deps.sh /usr/local/bin/setup-alpine-mysql-deps.sh
RUN chmod +x /usr/local/bin/setup-alpine-mysql-deps.sh && \
    setup-alpine-mysql-deps.sh

# 工作目录
WORKDIR /var/lib/mysql

# 配置文件
COPY my.cnf /etc/mysql/my.cnf

# 初始化 SQL 文件
COPY sql-init/*.sql /docker-entrypoint-initdb.d/

# 启动脚本
COPY scripts/setup-alpine-mysql-entrypoint.sh /usr/local/bin/setup-alpine-mysql-entrypoint.sh
RUN chmod +x /usr/local/bin/setup-alpine-mysql-entrypoint.sh

# 数据卷
VOLUME ["/var/lib/mysql"]

# 暴露端口
EXPOSE 3306

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD mysqladmin ping -u root -p"$MYSQL_ROOT_PASSWORD" || exit 1

# 启动命令
CMD ["setup-alpine-mysql-entrypoint.sh"]