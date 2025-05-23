## AI 助力 | 在 docker 中部署 mysql 服务

在 docker 中部署 mysql 服务，使用 alpilne 系统，使用 Dockerfile 文件，多阶段构建，支持中国网络和国际网络，默认使用中国网络。支持初始化数据导入。提供数据导入、导出、备份和还原操作指南。提供 docker cli 部署手册，提供 docker-compose 部署手册，提供 k8s 部署手册。


- 提供一个完整的双网络支持方案，确保在中国网络和国际网络环境下都能高效运行。


## 准备变量
```bash
# prefix="cong"
prefix="zero"
```

## 准备文件
```bash
sh -c "rm -f Dockerfile; cp Dockerfile-alpine Dockerfile;"
```


## 构建镜像 | 为不同的网络环境

```bash
# 为中国网络构建
docker build --build-arg NETWORK_REGION=cn -t ${prefix}-mysql:cn .

# 为国际网络构建
docker build --build-arg NETWORK_REGION=global -t ${prefix}-mysql:global .

# 添加 DOCKERFILE LABEL
docker build --build-arg NETWORK_REGION=cn -t ${prefix}-mysql:cn --label "dockerfile=$(cat Dockerfile | base64)" .

# 查看 DOCKERFILE LABEL
docker inspect ${prefix}-mysql:cn --format '{{index .Config.Labels "dockerfile"}}' | base64 -d

```

## 列出镜像
```bash
# 
sh -c "docker images | grep ${prefix}.*"

docker images -q --filter "reference=${prefix}-mysql*"
docker images -q --filter "reference=${prefix}*"


docker image ls --format "{{.ID}} {{.Repository}} {{.Tag}}" | grep "${prefix}-mysql"


# del untaged images
docker rmi $(docker images -f "dangling=true" -q)

# get images id with prefix
docker images --format "{{.ID}} {{.Repository}}" | grep "${prefix}" | awk '{print $1}'
# del images wih prefix
docker rmi $(docker images --format "{{.ID}} {{.Repository}}" | grep "${prefix}" | awk '{print $1}')

# get images name and tag  with prefix
docker images --format "{{.Repository}}:{{.Tag}}" | grep "${prefix}" 
```

## 运行容器 | 使用 .env 文件
```bash
# 使用 .env 文件运行容器，并在退出时自动删除
# docker run --rm --env-file .env -d --name mysql-test -p 3306:3306 zero-mysql-alpine:cn
docker run --rm --env-file .env -d --name mysql-test -p 3307:3306 zero-mysql-alpine:cn


# docker stop mysql-test && docker rm mysql-test
```

## 运行容器 | 启用或关闭 SQL 初始化

```bash
# 启用 SQL 初始化（默认）
docker run -d --name mysql-alpine -e INIT_SQL_FILES=true -p 3306:3306 ${prefix}-mysql:cn

# 关闭 SQL 初始化
docker run -d --name mysql-alpine -e INIT_SQL_FILES=false -p 3306:3306 ${prefix}-mysql:cn
```

## 进入容器
```bash
# 进入容器的 shell
docker exec -it mysql-alpine /bin/sh

# 进入 MySQL 命令行
# docker exec -it mysql-alpine mysql -u root -p"$MYSQL_ROOT_PASSWORD"
```

## 备份数据
```bash
# 创建备份目录
mkdir -p sql-backup

# 备份整个数据库
docker exec mysql-alpine mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" --all-databases > sql-backup/backup.sql

# 备份指定数据库
docker exec mysql-alpine mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" app_db > sql-backup/app_db_backup.sql

# 备份指定数据库的 schema（仅结构，不包含数据）
docker exec mysql-alpine mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" --no-data app_db > sql-backup/app_db_schema.sql

# 备份指定数据库的 data（仅数据，不包含 schema）
docker exec mysql-alpine mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" --no-create-info app_db > sql-backup/app_db_data.sql
```

## 导入数据
```bash
# 导入整个数据库
docker exec -i mysql-alpine mysql -u root -p"$MYSQL_ROOT_PASSWORD" < backup.sql

# 导入指定数据库
docker exec -i mysql-alpine mysql -u root -p"$MYSQL_ROOT_PASSWORD" app_db < app_db_backup.sql
```
