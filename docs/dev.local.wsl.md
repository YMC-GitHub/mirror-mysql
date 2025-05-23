## 构建镜像
- 在本地构建镜像，包含不同网络下的构建。带有cn，和global 两个标签。cn表示支持中国网络，global表示支持国际网络。带有zero前缀。


```bash
sh -c "rm -f Dockerfile; cp Dockerfile-alpine Dockerfile;"
```

1. 构建支持中国网络的镜像：
```bash
# docker build -t zero-mysql-alpine:cn --build-arg NETWORK=cn -f Dockerfile-alpine .
docker build -t zero-mysql-alpine:cn --build-arg NETWORK=cn .
```

2. 构建支持国际网络的镜像：
```bash
# docker build -t zero-mysql-alpine:global --build-arg NETWORK=global -f Dockerfile-alpine .
docker build -t zero-mysql-alpine:global --build-arg NETWORK=global .

```
这些修改利用了Docker的`ARG`指令，允许在构建时通过`--build-arg`参数来指定网络环境。`setup-alpine-apk-repos.sh`脚本会根据`NETWORK`参数的值来配置相应的镜像源。

## 列出镜像
```bash
sh -c "docker images | grep zero-mysql-alpine"
```

## 运行容器
```bash
# 使用 .env 文件运行容器，并在退出时自动删除
# docker run --rm --env-file .env -d --name mysql-test -p 3306:3306 zero-mysql-alpine:cn
docker run --rm --env-file .env -d --name mysql-test -p 3307:3306 zero-mysql-alpine:cn


# docker stop mysql-test && docker rm mysql-test
```

## 查看容器日志
```bash
docker logs mysql-test
```

## 进入容器
```bash
docker exec -it mysql-test /bin/sh
```


## 连接 MySQL 服务
```bash
mysql -u root -p
```
输入 `MYSQL_ROOT_PASSWORD`（可以在容器日志中找到）。

## 创建数据库和用户
```sql
CREATE DATABASE testdb;
CREATE USER 'testuser'@'%' IDENTIFIED BY 'testpassword';
GRANT ALL PRIVILEGES ON testdb.* TO 'testuser'@'%';
FLUSH PRIVILEGES;
```

## 验证操作
```sql
USE testdb;
CREATE TABLE test_table (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255));
INSERT INTO test_table (name) VALUES ('Test Data');
SELECT * FROM test_table;
```
## 退出 MySQL 服务
```sql
exit;
```

## 退出容器
```bash
exit
```

## 清理数据
测试完成后，停止并删除容器：

```bash
docker stop mysql-test
docker rm mysql-test
```

通过这些步骤，您可以在本地构建镜像并测试 MySQL 数据库的基本操作。